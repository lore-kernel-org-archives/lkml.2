Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1FNHfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:35:51 -0400
Received: from linux-sh.org ([111.68.239.195]:35117 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1FNHft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:35:49 -0400
Date: Tue, 14 Jun 2011 16:35:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ville Syrjala <syrjala@sci.fi>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] fbdev/atyfb: Fix 2 defined-but-not-used warnings
Message-ID: <20110614073531.GH17891@linux-sh.org>
References: <1307988778-21644-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307988778-21644-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 08:12:58PM +0200, Geert Uytterhoeven wrote:
> If CONFIG_FB_ATY_BACKLIGHT=y but CONFIG_PCI=n:
> 
> drivers/video/aty/atyfb_base.c:2272: warning: ???aty_bl_exit??? defined but not used
> 
> If CONFIG_ATARI=y for a modular build:
> 
> drivers/video/aty/atyfb_base.c:2794: warning: ???store_video_par??? defined but not
> used
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thanks.
