Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab1FJWvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:51:12 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27973 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab1FJWvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:51:11 -0400
Date: Sat, 11 Jun 2011 00:42:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Why is CONFIG_FHANDLE an option??
In-Reply-To: <20110610224738.GB11521@ZenIV.linux.org.uk>
Message-ID: <alpine.LNX.2.00.1106110040370.21722@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net> <20110610223955.GA11521@ZenIV.linux.org.uk> <20110610224738.GB11521@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Al Viro wrote:

> On Fri, Jun 10, 2011 at 11:39:55PM +0100, Al Viro wrote:
> 
> > Why not?  Software needs to test *anyway*, since it might run on earlier
> > kernels.  And "does that syscall return -ENOSYS" is self-documenting,
> > while "is the version higher than $MAGIC_NUMBER" is *not*.  Especially since
> > there's such thing as backports.
> > 
> > If you need to check that syscall is there, _check_ _it_.  Don't breed
> > dependencies on version numbers.
> 
> PS: we have BSD_PROCESS_ACCT doing pretty much the same kind of thing.
> And SYSVIPC.  And POSIX_MQUEUE.  And there's nfsservctl(2), also
> config-dependent.  And eventfd(2), and inotify syscalls, etc.
> 
> There is such thing as optional system calls.  Always had been.  Deal
> with that...

Yes, I'm aware of that. Doesn't mean we have to make things worse.
Just because we've had optional syscalls in the past doesn't mean we have 
to add more, nor that the existing ones were a good idea. IMHO they should 
be removed as options and just included unconditionally - not too late to 
correct this...


-- Jesper Juhl <jj@chaosbits.net>       
http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

