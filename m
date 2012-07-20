Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2GTSnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2GTSni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:43:38 -0400
Subject: Re: linux-next: Tree for July 20 (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com
In-Reply-To: <5009823B.2010700@xenotime.net>
References: <20120720151322.d952c13390b3078b2a5505bd@canb.auug.org.au>
	 <5009823B.2010700@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 20 Jul 2012 19:42:09 +0100
Message-ID: <1342809729.2742.18.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-07-20 at 09:07 -0700, Randy Dunlap wrote:
> On 07/19/2012 10:13 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20120719:
> > 
> 
> 
> 
> 
> on i386 (modular):
> 
> ERROR: "__divdi3" [fs/gfs2/gfs2.ko] undefined!
> 
> or builtin:
> 
> fs/built-in.o: In function `gfs2_fallocate':
> file.c:(.text+0x232086): undefined reference to `__divdi3'
> 

Bob has sent me a patch to fix this, and I've just pushed it to the GFS2
-nmw git tree. Thanks for letting us know,

Steve.



