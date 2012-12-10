Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2LJL5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:57:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20829 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2LJL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:57:20 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-e3-50c5ce1e39be
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Joel Becker'" <jlbec@evilplan.org>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: "'Michal Nazarewicz'" <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
 <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com>
 <50B5C821.4000406@linutronix.de> <xa1ta9u1naik.fsf@mina86.com>
 <50B61695.50207@linutronix.de> <20121207231828.GM22789@localhost>
In-reply-to: <20121207231828.GM22789@localhost>
Subject: RE: [RFC][PATCH] fs: configfs: programmatically create config groups
Date: Mon, 10 Dec 2012 12:57:02 +0100
Message-id: <001401cdd6cd$788defa0$69a9cee0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3U0TJBfo0fENkFSouKrnc4rwAdawB5wojw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xK7py544GGPT+ZbS4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU8fN3CWHAoq+LBx6WsDYwrQroYOTkkBEwkpk07xgZh
	i0lcuLceyObiEBJYyijx5tkFRpCEkEADk0TvlnwQm03AWGLvwQ6wuIhArMTW5U/YQRqYBWYw
	SSy+e4AZovsBk8S0ya9ZQao4BfQl3jx4DNYhLOArMWXpOhYQm0VAVeLy5VfMIDavgLXErF2n
	oWxBiR+T74HVMAtoSWze1sQKYctLbF7zFqiGA+hUdYlHf3UhjjCS2H58EztEiYjE3YbnrBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIUH/Zwbj4mNUh
	RgEORiUe3gDFowFCrIllxZW5hxglOJiVRHjFTgKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MKa/
	a9BoqBSelJ98SMTtNP8tNuHdlbUZ5m/tlpTLJW6drXiA0T/j+9MLR0R0Z5hNXl9ltqJ/3jf+
	zturFezD9zJO7q8OFlGr/+zW1NQu0eqh189+LuTnxdYX6cXLNBa5qfWtrHjXrv/B8ouGZ5ry
	Cq7YuzO2nXt1jWvm1a8fdqx77XyIV3KVohJLcUaioRZzUXEiAOckpPtIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joel,

So you are alive, I'm glad to hear from you ;) Thank you for your response.

On Saturday, December 08, 2012 12:18 AM Joel Becker wrote:
> Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
> groups
> 
> Hey Guys,
> 	Sorry I missed this for a while.  I'll make a couple of inline
> comments, and then I'll summarize my (incomplete) thoughts at the bottom.
> 
> On Wed, Nov 28, 2012 at 02:50:13PM +0100, Sebastian Andrzej Siewior wrote:
> > On 11/28/2012 02:05 PM, Michal Nazarewicz wrote:
> > >>On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
> > >>>How should a generic tool know what kind of actions are needed for
> > >>>given function to be removed?  If you ask me, there should be a way
> > >>>to unbind gadget and unload all modules without any specific
> > >>>knowledge of the functions.  If there is no such mechanism, then
> > >>>it's a bad user interface.
> 
> 	Please remember that configfs is not a "user" interface, it's a
> userspace<->kernelspace interface.  Like sysfs, it's not required to be
> convenient for someone at a bash prompt.  My goal is that it is *usable*
> from a bash prompt.  So it must be that you can create/destroy/configure
> objects via mkdir/rmkdir/cat/echo, but you might have a lot of those
> mkdir/echo combos to configure something.
> When it comes to the "user" interface, a wrapper script or library should
> be converting a user intention into all that boilerplate.
> 

If you say so there is little we can do, is there? :O

<snip>

> 
> 	Yeah, user tools are expected (and should be).
> 

ditto

> > Anyway, for this to work we have to go through Joel.
> >
> > >	rmdir udcs/*		# unload all UDCs
> >
> > No, for this you still have to rmmod :)
> >
> >
> > >>>I think the question is of information flow direction.  If user
> > >>>gives some information to the kernel, she should be the one
> > >>>creating any necessary directories.  But if the information comes
> > >>>from kernel to the user, the kernel should create the structure.
> 
> 	This last paragraph actually describes the distinction between
> configfs and sysfs.  More specifically, if userspace wants to create an
> object in the kernel, it should use configfs.  If the kernel has created
> an object on its own, it exposes it via sysfs.  It is a deliberate non-
> goal for configfs to replicate sysfs behavior.

So if the lifetime of some object is controlled by the user, it belongs
to configfs. If, on the other hand, the lifetime is controlled by the
kernel, it belongs to sysfs. I think that the trouble with e.g. luns
is that they might want to behave like both (at least in the "more
automated"
approach where they are programmatically created): they are created
by the kernel (=> sysfs) but their lifetime is controlled by the user
(=>configfs).

> 
> [General Thoughts]
> 
> 	First let me restate your problem to see if I understand it.
> 	You want to expose e.g. five LUNs.  They should eventually appear in
> configfs as five items to configure (.../{lun0,lun1,...lun4}/.  The
> current configfs way to do this is to have your setup script do:
> 
> 	cd /cfg/.../mass_storage
> 	mkdir lun0
> 	echo blah >lun0/attr1
> 	echo blahh >lun0/attr2
> 	mkdir lun1
> 	echo blag >lun1/attr1
> 	echo blagg >lun1/attr1
> 	...
> 
> I think the primary concern expressed by Andrzej is that a random user
> could come along and say "mkdir lun8", even though the gadget cannot
> support it.  A secondary concern from Michal is that userspace has to run
> all of those mkdirs.  The thread has described varying solutions.
> 	If these original directories were default_groups, you could
> disallow any child creation and not require the setup script to create
> directories.  Here I will point out that you *can* create default_groups
> programmatically.  The default_groups pointer on each configfs_group can
> be different.  ->make_group() can attach whatever groups it wants.
> If this would work, it would fit both of your concerns, but you do not
> have a priori knowledge of the LUN count.
> 	Your original email proposed that the max lun be set like so:
> 
> 	cd /cfg/.../mass_storage
> 	echo 5 >luns_allowed
> 
> There are then a couple of proposed ways to enforce the limit.  Your
> ->create_group() idea wants luns_allowed to be able to create subdirs in
> the ->store() function.  No ->mkdir() is provided, so a lunN cannot be
> created by hand.
> 	The ->create_group() idea has three challenges.  First, it creates
> "default" groups *after* the object is created.  This makes no sense if
> they are attributes of the toplevel object.  Second, it volates the
> configfs mantra that user-generated objects are explicitly created.
> The kicker, however, is the technical problem.  configfs explicitly
> forbids tree changes inside attribute operations for deadlock reasons.
> Trying to create new tree parts in luns_allowed->store() is exactly that.
> 	Another suggestion (I think I read this in the thread) would be to
> have ->mkdir() function parse the name and check that it is lunN, where N
> is less than the limit.  I think that this was shot down because of
> parsing the LUN name.  I don't think that's too terrible, but there's
> certainly room for argument.
> 
> [Possible Solutions]
> 
> 	Before coming back to the proposed patch, let's look at what I might
> do if I were fitting this into configfs.
> 	I would actually do what I described at first:
> 
> 	cd /cfg/.../mass_storage
> 	mkdir lun0
> 	echo blah >lun0/attr1
> 	...
> 
> This is idiomatic configfs usage.  Sebastian noted this earlier in the
> thread.  Michal thought the repeated mkdirs were a problem ("I think
> that's suboptimal, and we can do better").  This is Michal's objection to
> making the user do work.  This is where I point out we are not designing
> configfs interfaces for ease of end-user use.  We're defining them for
> transparent and discoverable interfaces for tools to create things in the
> kernel.  So the repeated mkdir()s are actually a good thing from my
> perspective; userspace is telling the kernel to create LUN objects.
> 	But this doesn't alleviate Andrzej's primary concern, nor does it
> answer Michal's concerns about corner cases.  Let's see if we can solve
> those.
> 	First, what about preventing extraneous LUNs?  There are two
> approaches: the prevent approach, and the ignore approach.  In the Target
> module, they take the ignore approach.  If you create a LUN that is
> outside the scope, they just ignore it.  So a user can make 10 LUNs, but
> if only five are allowed, the other five are ignored.  In the prevent
> approach, we try to fail the mkdir() when we go over the limit.

I think I like the prevent approach better, because I don't know what to
do with the unused luns in the ignore approach. I also think that it would
be nice if configfs described the actual state of the system instead of
presenting all the possible user-created garbage (i.e. something which is
ignored).

> 	So you've set a limit with "echo 5 >luns_allowed".  How do you
> restrict?  If you don't care about contiguous LUN numbering, you could
> literally do this in your make_group():
> 
> 	if (count_luns(parent) >= parent->luns_allowed)
> 		return -ENOSPC;
> 
> Note that we don't check the LUN number; SCSI does not require contiguous
> numbering.  It does require LUN 0, which should probably be a default
> group.  So your lun count starts at 1.
> 	What if you decide you really want contiguous LUN numbers, which is
> considered nice to have?  Then we get to Michal's concern about parsing
> the name.  If you "mkdir lun1", the code has to confirm that it
> a) starts with "lun", b) finishes with a parsable number, c) that number
> is < luns_allowed.
> 	But you need to do the parsing anyway!  If the LUN is created via
> mkdir(), somehow the gadget system needs to know what LUN number to
> advertise.  I would actually decouple it from the name.  The name should
> be free-form; if it happens to be comprehensible, that's good.  Imagine
> this:
> 	cd /cfg/.../mass_storage
> 	echo 4 >max_lun_id
> 	mkdir lun100
> 	echo 1 >lun100/lun_id
> 
> The LUN actually has the ID of 1.  The fact that the directory name is
> wrong is irrelevant to the gadget processing; non-hackers use the tooling,
> and the tooling should  make sane names.  Then your
> ->make_group() function can choose either approach to avoiding LUN IDs
> that are too large.  It can prevent:
> 
> 	lun_id->store() {
> 		if (lun_id_exists(parent, value))
> 			return ERR_PTR(-EINVAL);
> 		if (value > parent->max_lun_id)
> 			return ERR_PTR(-ENOSPC) /* or EINVAL */
> 		setup_lun();
> 		make_live();
> 	}
> 
> Or it can ignore:
> 
> 	lun_id->store() {
> 		if (lun_id_exists(parent, value))
> 			return ERR_PTR(-EINVAL);
> 		if (value <= parent->max_lun_id) {
> 			setup_lun();
> 			make_live();
> 		}
> 		/* Do nothing for the ignored sucker */
> 	}
> 
> 	I think that I, personally, would go with this <name>/lun_id scheme.
> Given a requirement for contiguous LUNs and the max_lun_id restriction,
> I'd go with the "prevent" option myself.

Taking into account what you say about the expected userspace tooling
using a free-form name plus the lun_id attribute could be attractive,
because the lun_id attribute's value can be analyzed at ->store() and,
if it doesn't fit, an appropriate error can be easily returned using
just what we already have in configfs. Prevent seems better to me, too.

> 	But is max LUNs a requirement?  Why not just have the LUN count be
> the number of LUNs created?  In that case, you can allow or disallow
> discontiguous LUN IDs without worrying about a max ID.
> 

I am not sure, but I think that Michal would say that he wouldn't like
things to change once the gadget is up and running, so the number of
luns should be fixed up front. On the other hand, after the gadget is
set up, we can fail in ->make_group() to prevent the user from creating
additional luns with which we don't know what to do. So what you suggest
seems fine, but I would ask Michal to be on a safe side.

> [Really Hate Mkdir]
> 
> 	If you considered it appropriate for the LUN objects to be created
> by the kernel, the standard way would to have "echo 5 >luns_allowed"
> create LUN objects in sysfs.  Yes, sysfs.
> There's no reason you can't have things in configfs *and* sysfs.  My
> understanding of your code says to me that the mkdir approach is the way
> to go, but if you hate it, this works.
> 

I guess you are right, but see my point about luns' lifetime being
controlled by the user and their creation being performed by the kernel.

> [What About the Patch?]
> 
> 	In general, attribute setting that turns into created configfs
> objects is against the theory of configfs.

This looks like an authoritative answer.

> In practice, it's a nightmare
> locking change.  Coming into this discussion, I though you were doing
> dymanic things at ->make_group() time, but that is already supported.
> 	But I want to hear your thoughts.  I've dumped a bunch of alternate
> approaches here.  Do any seem to fit?  What other challenges do you see?
> 
> Joel
> 

Once upon a time, Felipe expressed interest in having the information
about endpoints and interfaces (mostly read-only stuff, but not all of it)
accessible in the gadget subsystem in configfs. This kind of information
is fully available only after the gadget has been bound, that is, after
the user created all the groups/items and filled all the attributes
and told the gadget to start (with e.g. filling some attribute or
creating a symlink). So this looks like a programmatic creation of
configfs directories. On the other hand, Felipe wanted it for debugging
purposes, so the user could just as well create the required directories
by hand when they need to, as Sebastian once suggested. Again, this requires
->make_group() to fail if all the information is not available yet.
But isn't it kind of similar to the luns' case? It is a bunch of objects
whose lifetime is controlled by the user (bind the gadget, unbind the
gadget),
but which are created by the kernel.
Another problem with this is that the user must at some point _guess_
what name to use in mkdir. Example:

For each interface there should be a folder. So the user must know how many
interfaces' folders to create and how to name them, like:

$ mkdir ...../some_usb_function/interface00
$ mkdir ...../some_usb_function/interface01
...
...
...

In each interface folder, there should be some endpoint folders and the user
must know how many endpoints there are and how to name them:

$ mkdir ...../some_usb_function/interface00/endpoint02
$ mkdir ...../some_usb_function/interface00/endpoint81

So probably there should be some attribute in some_usb_function,
which contains a list of available interface names, and some attribute in
interface#, which contains a list of available endpoint names.
Workable, but not so convenient. And there could be a problem, too,
if the gadget is unbound: there is no way to remove the user-created
directories other than by the user themselves, so there will be times
(i.e. between gadget unbind and manual rmdir) when these interface/endpoint
directories will not correspond to anything present in the system.

So maybe this kind of information should live in sysfs? But I don't
know now if it would be any easier. Joel? Felipe?

AP


