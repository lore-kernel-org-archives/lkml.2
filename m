Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2FSXbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:31:52 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:30374 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab2FSXbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:31:50 -0400
Date: Wed, 20 Jun 2012 00:31:46 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Message-ID: <20120619233146.GA19796@milliways>
References: <20120618215323.GA17561@milliways>
 <1340057002.20570.31.camel@lade.trondhjem.org>
 <20120618221052.GA18341@milliways>
 <20120619010641.GA22288@milliways>
 <1340122836.3754.9.camel@lade.trondhjem.org>
 <1340123001.3754.11.camel@lade.trondhjem.org>
 <20120619165520.GA11015@milliways>
 <1340127987.3754.16.camel@lade.trondhjem.org>
 <20120619193540.GA14702@milliways>
 <1340145877.3754.39.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340145877.3754.39.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=wom5GMh1gUkA:10 a=3oYqF3-p60YA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=JDjsHSkAAAAA:8 a=BVKuDvXSPEYpES7BCyUA:9 a=QEXdDO2ut3YA:10 a=Hf6muOzgCGQA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:44:38PM +0000, Myklebust, Trond wrote:
> On Tue, 2012-06-19 at 20:35 +0100, Ken Moffat wrote:
> >  Unfortunately, no difference (on top of -rc3).
> > 
> >  FWIW, after rsync stalled I tried a download from firefox, to a
> > different nfs mount, and that too appeared to lock up firefox.
> 
> OK, I think I see what the problem is...
> 
> Does the following patch work for you?
> 
> Cheers
>   Trond
> 8<------------------------------------------------------
> From 1a0de48ae56b5cdb9a46b3d3a0b578dd7f787f22 Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Tue, 19 Jun 2012 18:38:56 -0400
> Subject: [PATCH] NFS: Initialise commit_info.rpc_out when
>  !defined(CONFIG_NFS_V4)
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: Fred Isaman <iisaman@netapp.com>
> ---
>  fs/nfs/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
 Yes :)

 On top of 3.5-rc3, without the previous patch.  I did two backups
(different filesystems) and then three downloads from firefox.

 Many thanks!

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
