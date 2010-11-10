Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0KJIYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:24:07 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24056 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0KJIYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:24:03 -0500
Date: Wed, 10 Nov 2010 09:12:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        devel@driverdev.osuosl.org, Dan Carpenter <error27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 10/17][trivial] staging, bcm: Remove unnecessary casts
 of void ptr returning alloc function return values
In-Reply-To: <20101110004543.GA28373@kroah.com>
Message-ID: <alpine.LNX.2.00.1011100911430.28522@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011082342560.23697@swampdragon.chaosbits.net> <20101110004543.GA28373@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Greg KH wrote:

> On Tue, Nov 09, 2010 at 12:09:51AM +0100, Jesper Juhl wrote:
> > Hi,
> > 
> > The [vk][cmz]alloc(_node) family of functions return void pointers which
> > it's completely unnecessary/pointless to cast to other pointer types since
> > that happens implicitly.
> > 
> > This patch removes such casts from drivers/staging/bcm/
> > 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  CmHost.c       |    2 +-
> >  InterfaceDld.c |   27 +++++++++++++--------------
> >  Misc.c         |   12 +++++-------
> >  3 files changed, 19 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
> 
> This driver just got a major overhaul, and this patch doesn't apply
> anymore.
> 
> Care to redo it against the next linux-next tree?
> 

Sure thing. I'll see if I can find the time to do that tonight when I get 
home from work.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

