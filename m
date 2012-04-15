Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2DOSOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 14:14:16 -0400
Received: from tex.lwn.net ([70.33.254.29]:56013 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab2DOSOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 14:14:14 -0400
Date: Sun, 15 Apr 2012 12:14:13 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Miller <davem@davemloft.net>
Cc: operational.people@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Where I can find the guide/help to device driver development
Message-ID: <20120415121413.111a7461@lwn.net>
In-Reply-To: <20120415.003704.657782177790226484.davem@davemloft.net>
References: <CAKB833=3-a+gkyOHnBwpq2dTiQkVk3p-ZYSQP7rS_rgXYhq6zQ@mail.gmail.com>
	<20120415.003704.657782177790226484.davem@davemloft.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2012 00:37:04 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Vishal Nandanwar <operational.people@gmail.com>
> Date: Sun, 15 Apr 2012 09:59:02 +0530
> 
> > I am new in Linux device driver development. Currently I am learning
> > drivers from the book "Linux device drivers" by Rubini. This book is
> > quite big and quite boring. What are the ways to learn the drivers?
> > 
> > Do any one have any guide in video or PPT format or in any other format?  
> 
> Sorry, nobody is going to produce and direct a science fiction film
> about kernel development just to make it more interesting for you.

I don't know...this could actually be kind of fun...

EPISODE 4: A NEW HACK

Our hero Luke is happily gaming away when his whole system goes up in
flames.  He encounters a pompous whitespace-specialist robot accompanied by
an R2-format USB stick in search of Obiwan Rubini.  Luke realizes he knows
Obiwan, a reclusive, bearded figure seen as boring by younger folks, but
known to the older generation as the source of great wisdom.  Obiwan is
able to decrypt a video on the R2, finding a plea for help from Princess
Leianux, who is in great need of help.

Obiwan takes the group to the Black Thorn Cantina, known to be an
occasional gathering place for great hackers in the early days; there they
encounter Alan Solo, who is able to offer the services of his beat up old
development system.  As they travel, Obiwan begins to teach Luke the
secrets of the Gnudi Hackers and how to use the light side of The Source.
Luke gets frustrated; it seems he is spending all his time being zapped by
compilation errors and configuration variables, but Obiwan insists that one
must follow the path, even if it's boring, lest one end up on the dark
side, where binary blobs and DRM are to be found.

There is an early encounter with Darl McVader and his fearsome squads of
imperial IP lawyers, but our heroes are lucky: while the lawyers may look
scary, they are unable to shoot well enough to hit the side of a Java heap
allocator.  They are able to rescue the princess and head off to join the
rebel hackers with the top-secret Death Box datasheet that the princess was
able to copy.  Luke's training continues; by the time they join the rebels,
he has a sense for char drivers, has learned all about printk(), and can
sometimes feel the presence of a bug with his eyes closed.  He has also,
like any aspiring Gnudi, built his own weapon: an ftrace saber of great
sharpness.

This episode ends with a climactic encounter at the Death Box, which is
threatening our hackers with a litigation ray of unprecedented power.  But,
by this point, Luke has learned the power of kmalloc() and feels ready.
Analysis of the datasheet, along with some rebel reverse engineering, has
turned up a zero-day vulnerability in the Death Box; it is Luke's job to
drop a patch into it and jailbreak the whole thing.  In the end, when all
appears lost, Luke turns off his debugger and, using his growing ability
to be one with the Source, gets his patch in just before the merge window
closes and everybody lives happily ever after.

Or at least until...

EPISODE 5: THE VENDOR STRIKES BACK

The empire discovers the rebels' secret repository and succeed in getting
it taken off the net; the rebels, faced with injunction-bearing AT-AT
walkers, are forced to flee.  Luke, realizing that he must grow his Gnudi
development skills, heads off to the swampy LKML system to study under the
great master Ts'oda.  He learns of block drivers, DMA, and signals, but,
impatient to earn his place in the top-20 contributors list and heedless of
Ts'oda's admonition that "changeset counts make not one great!", he leaves
before his training is complete.

Darl McBride is able to exploit this impatience to set up a race condition
and force Luke into a triple fault situation.  As the battle winds down,
Luke learns that his nemesis is, in fact, his parent process; Darl offers a
sharing of resources, but Luke NAKs the idea and chooses to oops instead.
Happily he is able to kexec() into a new image, leaving open the
possibility of a proper reboot in a future episode.  Meanwhile, though,
Alan Solo has been manipulated into a hard-frozen non-compete agreement and
is effectively removed from the scene.

EPISODE 6: THE RETURN OF THE GNUDI

Princess Leianux and Luke are able to rescue Alan Solo from his
non-compete, which had been transferred to Ballmer the Hutt; the rescue
involves an unlikely escape from the extreme Sarlacc memory leak.  Luke
returns to LKML to finish his training, hoping to learn about race
conditions, concurrency, and mutual exclusion, but finds that the server
has been compromised; Luke has no alternative to learning from the Source
directly.

It seems that the Death Box is being rebooted with new firmware, a
regression that, from the rebels' point of view, must be reverted
immediately.  The alliance stages a daring attack, hoping to shut it down
before it goes multiuser, only to discover "It's a BPT trap!" and the Box
is already at full capability, and, even worse, is running systemd.  It
looks like a dark time for the Gnudi.

But Alan Solo and Leianux are able, with the help of an army of long-haired
smellies and a simple credential-spoofing attack, to get into the shield
generator and disable SELinux.  Luke manages to defeat Darl McVader in a
vicious editor battle, but, despite the init process's goading, is
unwilling to kill McVader and cause himself to be reparented to Init
directly.  McVader himself attaches to Init, putting him into the zombie
state; McVader, it seems, has cast off his binary blobs and returned to the
light.  

The Death Box is rooted once again.  Luke adds his Acked-by to the merge of
Alan Solo and Princess Leianux, then, with signoffs from Ts'oda, McVader,
and Obiwan Rubini, takes his place as a proper Gnudi subsystem maintainer.

EPISODE 1: THE PATCHBOMB MENACE

To be written in about 20 years; look for the thrilling appearance of
Jar-Jar Bunks!

I guess I better get some real work done now.

jon
