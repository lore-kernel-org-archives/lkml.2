Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2EWGMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:12:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41946 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2EWGMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:12:40 -0400
Date: Tue, 22 May 2012 23:12:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for 3.5-rc1 - try 2
Message-ID: <20120523061216.GA19584@kroah.com>
References: <1337723927.9270.15.camel@joe2Laptop>
 <20120522220534.GC12705@kroah.com>
 <1337724736.11918.8.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337724736.11918.8.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 03:12:16PM -0700, Joe Perches wrote:
> On Tue, 2012-05-22 at 15:05 -0700, Greg KH wrote:
> > On Tue, May 22, 2012 at 02:58:47PM -0700, Joe Perches wrote:
> > > How is it really better that what is available now?
> > > 
> > > Perhaps it would be better to respin all the
> > > printk modifications without adding [v]printk_emit
> > > and have the [v]printk_emit bits debated a bit more.
> > 
> > I'm always glad to review patches, but to just propose something that
> > works to be reverted without a patch to replace the functionality, isn't
> > ok.
> 
> It hasn't been committed yet in anything other than
> -next.
> 
> Lots of stuff gets committed there and later removed
> and hits Linus' mainline tree.

Sorry, but as people are "downstream" for me, I do not rebase my trees,
unless something really bad happened (i.e. I messed up the tree).  So
this will not happen, sorry.

Also, the patches are all in Linus's tree now, so the point is moot.

thanks,

greg k-h
