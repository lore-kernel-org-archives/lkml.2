Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2LQQM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:12:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LQQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:12:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] asm-generic/dma-mapping-broken.h: Provide dma_alloc_attrs()/dma_free_attrs()
Date: Mon, 17 Dec 2012 16:12:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1355679527-1207-1-git-send-email-geert@linux-m68k.org> <1355679527-1207-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1355679527-1207-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212171612.44126.arnd@arndb.de>
X-Provags-ID: V02:K0:ebAV1QZP6Rbs334LArM7B/zTWpPZl6cg7x0UYmPQyT0
 T6a1DzNXWOLnyEe0a43dFIVlngT2YVxfPro2NOrT78C3o6ATe+
 jS2KvexmMSQt4TBTb8n+EEKTcAsmrwsdkI6zxfb9Icl8IJbAmU
 /eXbDpEqRKZbKeWe+oPfFgy6RuXh04khnI/27xZ4tjWw33iVJe
 9APMT7BPsvnl4HO2xvZ+MgazUP3h4kpVAJg0gavXnyQ7/Qj+KZ
 hPgxLj81MssalUHwky0rvSZSjHAA/2oQ3uX9LMgwh7xS7eGPfs
 /B1Ct2k7W2gxBS/pofKMAhC0TNJNcz4JssLErHb6OJLGiFWcpC
 FxMDIIwxHcLWC25OBfx4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 December 2012, Geert Uytterhoeven wrote:
> 
> Since commit 0049fb2603b7afb1080776ee691dfa5a3d282357 ("OMAPFB: use
> dma_alloc_attrs to allocate memory") we have one non-arch user of
> dma_{alloc,free}_attrs().
> 
> Hence provide these functions, as wrappers around
> dma_{alloc,free}_coherent().
> 
> Note that most architectures do it the other way around. But as these are
> dummy functions, we don't care.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  include/asm-generic/dma-mapping-broken.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)

Acked-by: Arnd Bergmann <arnd@arndb.de>

Maybe you can put this one in your m68k tree along with your other
patch.

	Arnd
