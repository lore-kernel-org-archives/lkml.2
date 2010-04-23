Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0DXIaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 04:30:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:54807 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0DXIaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 04:30:21 -0400
Subject: Re: [PATCH] procfs: fix tid fdinfo
From: Miklos Szeredi <mszeredi@suse.cz>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100424192735.GA5157@x200>
References: <4BD1BF57.7070201@redhat.com>
	 <20100423111620.100840fe.akpm@linux-foundation.org>
	 <20100424192735.GA5157@x200>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 22:07:19 +0200
Message-ID: <1272053239.4456.4.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-24 at 22:27 +0300, Alexey Dobriyan wrote:
> On Fri, Apr 23, 2010 at 11:16:20AM -0700, Andrew Morton wrote:
> > On Fri, 23 Apr 2010 17:40:07 +0200
> > > -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
> > > +	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> 
> > hm, the code's been like that for over a year.  What are the
> > user-visible effects of the bug, and of this change?
> 
> /proc/*/task/*/fdinfo contains symlinks to opened files like /proc/*/fd/
> which is cool bug :-)

Yeah, at least now we can see that someone has started using this
interface ;)

Jerome, thanks for spotting this!

Miklos


