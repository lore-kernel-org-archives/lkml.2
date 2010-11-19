Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab0KSIGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:06:17 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33660 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0KSIGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:06:16 -0500
Date: Fri, 19 Nov 2010 17:05:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 00/05] fbdev: SH-Mobile MIPI-DSI Update
Message-ID: <20101119080536.GC28165@linux-sh.org>
References: <20101117064405.18139.57035.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117064405.18139.57035.sendpatchset@t400s>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:44:05PM +0900, Magnus Damm wrote:
> fbdev: SH-Mobile MIPI-DSI Update
> 
> [PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
> [PATCH 02/05] fbdev: sh_mipi_dsi: Make use of register names
> [PATCH 03/05] ARM: mach-shmobile: Extend AP4EVB MIPI-DSI resources
> [PATCH 04/05] fbdev: sh_mipi_dsi: Require two I/O resources
> [PATCH 05/05] fbdev: sh_mipi_dsi: Allow LCDC board callbacks
> 
Ok, I've applied the updated version of this with 01/05 dropped and 04/05
replaced with the V2 version. In the future make sure to Cc the
linux-fbdev list, too.
