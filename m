Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab0KLRUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:20:55 -0500
Received: from mail.lixom.net ([70.86.134.90]:41721 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0KLRUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:20:54 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 12:20:54 EST
Date: Fri, 12 Nov 2010 11:14:23 -0600
From: Olof Johansson <olof@lixom.net>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, kmpark@infradead.org,
        konkers@android.com, tony@atomide.com, adharmap@codeaurora.org,
        avorontsov@mvista.com, linux-kernel@vger.kernel.org,
        srinidhikasagar@gmail.com, dwalker@codeaurora.org,
        santosh.shilimkar@ti.com, ccross@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/07] ARM: Use shared GIC entry macros on Tegra
Message-ID: <20101112171423.GC27647@lixom.net>
References: <20101112082059.27221.52879.sendpatchset@t400s> <20101112082141.27221.50202.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112082141.27221.50202.sendpatchset@t400s>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 05:21:41PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Use the GIC demux code in asm/hardware/entry-macro-gic.S
> on the Tegra subarchitecture.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof

