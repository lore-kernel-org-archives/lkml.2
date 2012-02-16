Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2BPCMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:12:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34810 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab2BPCMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:12:31 -0500
Date: Wed, 15 Feb 2012 18:12:23 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, artem.bityutskiy@intel.com, w.sang@pengutronix.de,
        LW@KARO-electronics.de, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, cjb@laptop.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] mxs-dma : rewrite the last parameter of
 mxs_dma_prep_slave_sg()
Message-ID: <20120216021223.GF30946@r65073-Latitude-D630>
References: <1329110756-14434-1-git-send-email-b32955@freescale.com>
 <1329110756-14434-3-git-send-email-b32955@freescale.com>
 <20120215195552.GB2399@r65073-Latitude-D630>
 <4F3C6466.9000500@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3C6466.9000500@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 10:05:26AM +0800, Huang Shijie wrote:
> Hi Shawn:
> >I'm trying to give it a test.  But it does not apply on either mainline
> >or next tree.  You probably had a wrong base for this patch.
> >
> thanks for your work.
> 
> As the previous email said, this patch set bases on :[PATCH v2]
> mtd/gpmi : add gpmi support for mx6q.
> 
Then you are doing something wrong.  This series should be based on
mainline, and then you add imx6q support on top of this series.

-- 
Regards,
Shawn
