Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2CAJ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:58:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52472 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab2CAJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:58:49 -0500
Date: Thu, 1 Mar 2012 10:58:48 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator mc13783: bail out without platform data
Message-ID: <20120301095848.GZ3852@pengutronix.de>
References: <1330502500-30567-1-git-send-email-s.hauer@pengutronix.de>
 <20120229231951.GB8295@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229231951.GB8295@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:58:11 up 109 days, 17:45, 34 users,  load average: 0.02, 0.25,
 0.41
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:19:51PM +0000, Mark Brown wrote:
> On Wed, Feb 29, 2012 at 09:01:40AM +0100, Sascha Hauer wrote:
> > the platform data pointer is used without checking it. Bail out
> > in the driver instead of crashing the kernel.
> 
> Applied, thanks.  Ideally the platform data would just specify the
> constraints and the driver would still be able to register the
> regulators even without constriants being provided to allow diagnostics.

Indeed. I can follow up on this when I find the time. For now I'm happy
with the kernel not crashing.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
