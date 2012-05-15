Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab2EOPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:23:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:32798 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964963Ab2EOPXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:23:13 -0400
Date: Wed, 16 May 2012 01:14:27 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
In-Reply-To: <1337043086.25191.3.camel@falcor>
Message-ID: <alpine.LRH.2.02.1205160113550.939@tundra.namei.org>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>  <alpine.LRH.2.02.1205151028450.26396@tundra.namei.org> <1337043086.25191.3.camel@falcor>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Mimi Zohar wrote:

> On Tue, 2012-05-15 at 10:29 +1000, James Morris wrote:
> > On Sun, 13 May 2012, Mimi Zohar wrote:
> > 
> > > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > > 
> > > This patch has been updated to move the ima_file_mmap() call from
> > > security_file_mmap() to the new vm_mmap() function.
> > 
> > Which kernel is this for?
> 
> Commit #6be5ceb(VM: add "vm_mmap()" helper function) is in Linus' master
> tree, but the posted patch is against linux-security/next.

I'm still not sure what the answer is :-)

Can this wait until 3.5-rc1?


-- 
James Morris
<jmorris@namei.org>
