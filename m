Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2HaNFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:05:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46640 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2HaNFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:05:10 -0400
Date: Fri, 31 Aug 2012 15:05:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: i.MX pwm patches
Message-ID: <20120831130502.GR26594@pengutronix.de>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <20120830214547.GC3613@r65073-Latitude-D630>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830214547.GC3613@r65073-Latitude-D630>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:03:31 up 69 days,  4:15, 85 users,  load average: 0.16, 0.40,
 0.48
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 05:45:49AM +0800, Shawn Guo wrote:
> On Tue, Aug 28, 2012 at 01:48:15PM +0200, Sascha Hauer wrote:
> > Hi All,
> > 
> > The following patches are an overdue work on the i.MX pwm driver.
> > 
> > - introduce SoC specific functions to make the driver easier to maintain
> > - use peripheral clock for pwm output unconditionally
> > - separate the two clocks this module has
> > - enable ipg clock for register accesses, peripheral clock for enabling
> >   the pwm
> > - make the driver safe for calling pwm_config before pwm_enable
> > - Add devicetree support for i.MX53
> > 
> > The platform device support is still implemented using cpu_is_*, I think
> > this can be dropped completely soon
> 
> Anything stops us from doing this right now?  The bonus point of
> cleaning this is that we can remove the #include <mach/hardware.h>
> from the driver, which is helpful for single-kernel project.

The pwm driver currently has no in kernel user, so I'd say yes.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
