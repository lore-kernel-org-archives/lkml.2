Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2AHWVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:21:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17631 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2AHWVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:21:45 -0500
Date: Sun, 8 Jan 2012 23:21:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Subject: Re: Please merge two small bug fix patches from linux-next
In-Reply-To: <1326058974.5372.4.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1201082319560.24030@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201082028140.24030@swampdragon.chaosbits.net>  <CA+55aFwO9Wtq=NEpMskW-2wrWZAGh-C6VBXENA3LtFOk=tUwgQ@mail.gmail.com> <1326058974.5372.4.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jan 2012, Joe Perches wrote:

> On Sun, 2012-01-08 at 13:26 -0800, Linus Torvalds wrote:
> > On Sun, Jan 8, 2012 at 11:51 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > Below are two patches that have been in linux-next for ages (via akpm's
> > > tree). They are prette simple, straight-up, bug fixes. They have been
> > > submitted to maintainers multiple times over (IIRC at least the past
> > > year), but for some reason the maintainers seem uninterested in picking
> > > them up (or even responding to them).
> []
> > they seem to have Andrew's sign-off, so I'd have expected them to
> > come through Andew. What's up?
> 
> >From my perspective, the issue lies with James'
> apparent desire to keep scsi tree changes as close
> to zero as possible.
> 
> Many obvious corrections to scsi defects have gone
> unapplied.
> 

I have to agree. It's actually gotten to the point that I personally 
completely avoid/ignore scsi code when looking for stuff to fix/improve 
since I don't expect to be able to get the patches merged anyway..


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

