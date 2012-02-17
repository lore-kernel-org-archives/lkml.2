Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2BQQEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 11:04:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41198 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2BQQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 11:04:41 -0500
Date: Fri, 17 Feb 2012 11:01:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120217160120.GE31531@phenom.dumpdata.com>
References: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
 <20120216051552.GA5676@kroah.com>
 <c6634d7c-b264-4a87-bab1-74408341dab0@default>
 <20120217082559.6a094265da2d5c203bfc445f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217082559.6a094265da2d5c203bfc445f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F3E7A8F.0022,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is in next-20120215 (and has been since next-20120124).  However, I
> merge Konrad's (tmem) tree *after* I merge the staging tree, so that commit
> was not present when I tried to build linux-next after merging the
> staging tree.
> 
> > > > Caused by commit 19ee3ef5f4bb ("staging: ramster: local compression + tmem").
> > > >
> > > > I have used the staging tree from next-20120215 for today.
> > > 
> > > Dan, can you please fix this?
> > 
> > Hmmm... moving target.  I'm trying to get in touch with Konrad
> > to see if we can determine what is going on.
> 
> See above.
> 
> > The good news is that there seems to be an increasing number
> > of people contributing to and building things on top of
> > cleancache/frontswap stuff.  The bad news is that it is difficult
> > to avoid ordering dependencies that affect -next.  My apologies
> > and if you have any dependency-savvy processes that would solve
> > this that we are not using, please let me/us know.
> 
> Well, if anyone had bothered to tell me, I could have reordered the
> trees.  However, that does not change the fact that the staging tree is
> now broken on its own.  Which means that Greg can't even do unit testing
> on his tree with your code in it. :-(

Yikes. Stephen, if it is not too much trouble could you move my tree up
just a notch (or a couple) in your awesome build system? I hadn't realized
this dependency (thought it is obvious in hindsight).

Thanks!

P.S.
That won't fix Greg building his own linux-tree by itself, and the option of
using CONFIG_BROKEN should work just fine until 3.4 and which point that can be
reverted.
