Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0GIMyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 08:54:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab0GIMyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 08:54:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the final tree (block tree related)
Date: Fri, 9 Jul 2010 14:54:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100709143940.f0f06690.sfr@canb.auug.org.au>
In-Reply-To: <20100709143940.f0f06690.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091454.09011.arnd@arndb.de>
X-Provags-ID: V02:K0:Y0v9JoBJrUtBsxoGblRzxyX8HQ1VFEQKylRE7JelfYj
 QMykTMm3bfZkM5wdqB0PY+JgFP1/UQ9ZZJ2+VCaBIfK98DX+sV
 wapdy1NPUHPCoEI6hmZQWpQ42i6ftpGqTy8NK2NPgmE8IaFKBP
 5/ArzIDGJbMHxk43ZcFPieh1Gie1M4Zo3pGMl+yE7cwlYoNlsU
 b7DXg8YkIFE0iukfIykCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 July 2010, Stephen Rothwell wrote:

> I applied the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 9 Jul 2010 14:24:38 +1000
> Subject: [PATCH] block: fix for block tracing build error
> 
> block/compat_ioctl.c: In function 'compat_blkdev_ioctl':
> block/compat_ioctl.c:754: error: 'BLKTRACESETUP32' undeclared (first use in this function)

Yes, the fix looks right, sorry about the breakage.
I only tested with CONFIG_BLOCK_TRACE enabled, so I did not
catch this.

Jens, please apply Stephen's patch.
 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
