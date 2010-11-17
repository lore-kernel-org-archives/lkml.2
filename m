Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab0KQHsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:48:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48050 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758063Ab0KQHsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:48:20 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+OViZtVJSOYjYi7qAxaFAP9j/b9EfWro5ebY0YS6
	zWX2G2Hphtgfcf
Date: Wed, 17 Nov 2010 08:48:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 00/05] fbdev: SH-Mobile MIPI-DSI Update
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
Message-ID: <Pine.LNX.4.64.1011170846410.25275@axis700.grange>
References: <20101117064405.18139.57035.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Magnus Damm wrote:

> fbdev: SH-Mobile MIPI-DSI Update
> 
> [PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
> [PATCH 02/05] fbdev: sh_mipi_dsi: Make use of register names
> [PATCH 03/05] ARM: mach-shmobile: Extend AP4EVB MIPI-DSI resources
> [PATCH 04/05] fbdev: sh_mipi_dsi: Require two I/O resources
> [PATCH 05/05] fbdev: sh_mipi_dsi: Allow LCDC board callbacks

Thanks for the patches, Magnus! Agree with Paul regarding [PATCH 1/5], for 
2-5 here's an

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Regards
Guennadi

> 
> These patches contain a few rather trivial updates for the
> sh_mipi_dsi driver. Necessary changes to the AP4EVB specific
> platform data is also included in [PATCH 03/05]. It should
> be applied before [PATCH 04/05].
> 
> The patches above contain the following two major features:
> - Support newer SoCs with different I/O base adresses
> - Allow board-specific LCDC hooks together with MIPI-DSI
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  arch/arm/mach-shmobile/board-ap4evb.c |    7 +
>  drivers/video/sh_mipi_dsi.c           |  131 ++++++++++++++++++++-------------
>  2 files changed, 87 insertions(+), 51 deletions(-)
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
