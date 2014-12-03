###############################################
package Cell;
use strict;
use parent qw/Class::Accessor/;
__PACKAGE__->mk_accessors(qw/next data/);

sub new {
    my $class = shift;
    my $next = undef;
    my $data = shift;
    bless { next => $next, data => $data }, $class;
}

1;

###############################################
package LinkedList;
use strict;
use parent qw/Class::Accessor/;
__PACKAGE__->mk_accessors(qw/header/);

sub new {
    my ($class, %self) = @_;
    $self{'header'} = new Cell("!!List Header!");
    bless \%self => $class;
    return \%self;
}

sub insert {
    my $self = shift;
    my $num = shift;
    my $p = $self->header->next;
    my $q = $self->header;
    while ($p != undef && $num > $p->data) {
        $q = $p;
        $p = $p->next;
    }

    my $new_cell = new Cell($num);
    $new_cell->next($p);
    $q->next($new_cell);
}

sub iterator {
    my $self = shift;
    my $iter = LinkedListIterator->new($self);
    return $iter;
}

1;

###############################################
package LinkedListIterator;
use strict;
use parent qw/Class::Accessor/;
__PACKAGE__->mk_accessors(qw/list p/);

sub new {
    my ($class, $self) = @_;
    $self->{'p'} = $self->header;
    bless $self => $class;
    return $self;
}

sub hasNext {
    my $self = shift;
    return $self->p->next != undef;
}

sub next {
    my $self = shift;
    if ( $self->p->next == undef ) {
        return undef;
    }

    $self->p($self->p->next);
    return $self->p->data;
}

1;

###############################################
package main;

my $list = new LinkedList;
$list->insert(20);
$list->insert(15);
$list->insert(18);
$list->insert(37);
$list->insert(3);

print "--------------------\n";

my $iter = $list->iterator;
my $count = 1;
while ($iter->hasNext) {
   print $count++ . "番目の要素:" . $iter->next . "\n";
}

1;
