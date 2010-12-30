Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0L3R7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 12:59:55 -0500
Received: from mx2.netapp.com ([216.240.18.37]:1296 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab0L3R7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 12:59:54 -0500
X-IronPort-AV: E=Sophos;i="4.60,251,1291622400"; 
   d="scan'208";a="500401236"
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20101230171453.GA5787@pengutronix.de>
References: <20101230171453.GA5787@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 30 Dec 2010 12:59:52 -0500
Message-ID: <1293731992.4919.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 30 Dec 2010 17:59:53.0593 (UTC) FILETIME=[5C5EEE90:01CBA84B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 18:14 +0100, Uwe Kleine-König wrote: 
> Hello,
> 
> I wonder if the nfs-stuff is considered to be solved, because I still
> see strange things.
> 
> During boot my machine sometimes (approx one out of two times) hangs with
> the output pasted below on Sysctl-l.  The irq 
> 
> I'm not 100% sure it's related, but at least it seems to hang in
> nfs_readdir.  (When the serial irq happend that triggered the sysrq the
> program counter was at 0xc014601c, which is fs/nfs/dir.c:647 for me.)
> 
> This is on 2.6.37-rc8 plus some patches for machine support on an ARM
> machine.

Ccing linux-nfs@vger.kernel.org

What filesystem are you exporting on the server? What is the NFS
version? Is this nfsroot, autofs or an ordinary nfs mount?

In short, how can we reproduce this?

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

