Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0HSN3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:29:39 -0400
Received: from mv-drv-hcb004.ocn.ad.jp ([118.23.109.134]:53146 "EHLO
	mv-drv-hcb004.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0HSN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:29:36 -0400
X-Greylist: delayed 170641 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2010 09:29:35 EDT
Date: Thu, 19 Aug 2010 22:29:28 +0900 (JST)
Message-Id: <20100819.222928.35468456.anemo@mba.ocn.ne.jp>
To: fujita.tomonori@lab.ntt.co.jp
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: TX49xx: rename ARCH_KMALLOC_MINALIGN to
 ARCH_DMA_MINALIGN
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20100814160128H.fujita.tomonori@lab.ntt.co.jp>
References: <20100814160128H.fujita.tomonori@lab.ntt.co.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 16:02:37 +0900, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> Architectures need to set ARCH_DMA_MINALIGN to the minimum DMA
> alignment (the commit
> a6eb9fe105d5de0053b261148cee56c94b4720ca). Defining
> ARCH_KMALLOC_MINALIGN doesn't work anymore.

Thank you for picking this up.

Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
