Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2AHVfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 16:35:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17227 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab2AHVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 16:35:19 -0500
Date: Sun, 8 Jan 2012 22:35:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: Re: Please merge two small bug fix patches from linux-next
In-Reply-To: <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1201082228280.24030@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net> <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jan 2012, Linus Torvalds wrote:

> On Sun, Jan 8, 2012 at 11:51 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> >
> > Below are two patches that have been in linux-next for ages (via akpm's
> > tree). They are prette simple, straight-up, bug fixes. They have been
> > submitted to maintainers multiple times over (IIRC at least the past
> > year), but for some reason the maintainers seem uninterested in picking
> > them up (or even responding to them).
> > There has been no negative comments at all to them while they have been in
> > -next.
> > I'd really appreciate it if they could get merged.
> >
> > I've just pulled them out of the current linux-next and applied them on
> > top of your tree - that's what is below.
> 
> So where are they? Git tree or what?
> 
> And if you want me to apply them as patches, please send them as
> proper individual patches instead of askng me to "merge" them.
> 
> And they seem to have Andrew's sign-off, so I'd have expected them to
> come through Andew. What's up?
> 

What's up is this: I'd submitted them a few times to the mailing list and 
maintainers in the distant past. Andrew ended up picking them up when 
maintainers didn't. Through him they made it into the linux-next tree and 
have been living in Andrews queue and -next ever since. 

I simply got fed up with seeing them in -next and getting nowhere, and 
thought that if the maintainers won't pick them up maybe you would just 
take them directly now since it's been ages and they have not gotten any 
negative feedback and a merge window is open.

Andrew added his signed-off-by when he took them into his queue, I 
retained that when I grabbed the patches into a mainline git clone from 
-next, but I can just drop those if that's inappropriate.

I should not have said "merge" in the subject - my bad.

I'll send them as two individual patches by mail (unless you prefer a git 
tree, then I can easily set that up as well).


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

