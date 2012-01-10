Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2AJIje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:39:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57995 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2AJIjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:39:32 -0500
Date: Tue, 10 Jan 2012 09:39:22 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 2/4] ASoC: i.MX: Add missing dma_async_issue_pending
Message-ID: <20120110083922.GT5446@pengutronix.de>
References: <1326101570-3716-1-git-send-email-s.hauer@pengutronix.de>
 <1326101570-3716-3-git-send-email-s.hauer@pengutronix.de>
 <20120109161301.GB2974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109161301.GB2974@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:35:13 up 58 days, 16:22, 21 users,  load average: 0.00, 0.04,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 08:13:02AM -0800, Mark Brown wrote:
> On Mon, Jan 09, 2012 at 10:32:48AM +0100, Sascha Hauer wrote:
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but I guess I can just apply it immediately?

The ASoC patch (also the mmc driver patch) have to be applied
before the dma driver patches. To make this sure I think it's
best when Vinoud applies the whole series.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
