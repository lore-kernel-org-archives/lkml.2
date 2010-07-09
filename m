Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0GIM5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 08:57:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0GIM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 08:57:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] fix BLKTRACESETUP32 compile error
Date: Fri, 9 Jul 2010 14:57:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20100709085858U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100709085858U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007091457.23339.arnd@arndb.de>
X-Provags-ID: V02:K0:8k2jsYIO/Z/60DvJ9jBecxtTWniJwzSQ1JbrRwZ8gOR
 25CI+WANWycUS2S2w7csT/2/pgflLo66gIYzQRJhwrU4oS+64D
 80hSYc0yrihVZkbq7edkyZC1peQX1YjbAo0kJKyHqzIgc2J2jy
 5PeSh+weG8Vo4VUpwEO6pbk2Woo8LGOZ56TADKO1VoRuYPTMgX
 A7f3wO9PwwnHLUnFMlOGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 July 2010, FUJITA Tomonori wrote:
> I got the following compile error with block's for-2.6.36 tree:
> 
> block/compat_ioctl.c: In function compat_blkdev_ioctl:
> block/compat_ioctl.c:754: error: BLKTRACESETUP32 undeclared (first use in this function)
> block/compat_ioctl.c:754: error: (Each undeclared identifier is reported only once
> block/compat_ioctl.c:754: error: for each function it appears in.)
> 
> 
> This is due to "block: push BKL into blktrace ioctls" patch.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] fix BLKTRACESETUP32 compile error
> 
> We need BLKTRACESETUP32 even with CONFIG_BLK_DEV_IO_TRACE disabled.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Stephen sent an almost identical patch, either version looks good.
Sorry for breaking this.

Acked-by: Arnd Bergmann <arnd@arndb.de>
