Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab0KLQpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:45:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab0KLQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:45:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/07] ARM: Common GIC entry macro code V3
Date: Fri, 12 Nov 2010 17:46:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux@arm.linux.org.uk,
        kgene.kim@samsung.com, kmpark@infradead.org, konkers@android.com,
        tony@atomide.com, adharmap@codeaurora.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, srinidhikasagar@gmail.com,
        dwalker@codeaurora.org, santosh.shilimkar@ti.com, ccross@android.com,
        olof@lixom.net
References: <20101112082059.27221.52879.sendpatchset@t400s>
In-Reply-To: <20101112082059.27221.52879.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121746.07969.arnd@arndb.de>
X-Provags-ID: V02:K0:eGyUHfhnI+BkKMcJdlsWNCiJNNrTc/p8ANRrbcT9tjk
 QSaDaRAb8SOz93ZNGNJ0e+OKiuXZYy3uoUjH0R0q4qyzoVXfhu
 qp/oeZ1VVe9KEeeiE2h26nYzBwXrl0mgN/xzfPM+Y+3yIQVFi+
 OtQYSrw4tEkohiaVabz5wrlA2gpZXAyBNGv6AeupF+f5l12zj7
 peM8FxHSjtm+D04SFkbTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 November 2010, Magnus Damm wrote:
> ARM: Common GIC entry macro code V3
> 
> [PATCH 01/07] ARM: Introduce asm/hardware/entry-macro-gic.S
> [PATCH 02/07] ARM: Use shared GIC entry macros on CNS3XXX
> [PATCH 03/07] ARM: Use shared GIC entry macros on Realview
> [PATCH 04/07] ARM: Use shared GIC entry macros on Tegra
> [PATCH 05/07] ARM: Use shared GIC entry macros on UX500
> [PATCH 06/07] ARM: Use shared GIC entry macros on Vexpress
> [PATCH 07/07] ARM: Use shared GIC entry macros on OMAP
> 
> Put GIC demux code in a common place to avoid duplicated code.
> 

Looks like a very nice cleanup!

	Arnd
