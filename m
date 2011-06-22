Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1FVHJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 03:09:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57709 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1FVHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 03:09:49 -0400
Date: Wed, 22 Jun 2011 09:09:47 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv7] ARM: mx51: Add support for low power suspend on MX51
Message-ID: <20110622070947.GH6069@pengutronix.de>
References: <1301325297-24126-1-git-send-email-Dinh.Nguyen@freescale.com>
 <87k4cfa550.fsf@lebrac.rtp-net.org>
 <20110621223527.GF6069@pengutronix.de>
 <874o3i9x89.fsf@lebrac.rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874o3i9x89.fsf@lebrac.rtp-net.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:08:58 up 12:56, 22 users,  load average: 0.50, 0.39, 0.24
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 08:49:42AM +0200, Arnaud Patard wrote:
> Sascha Hauer <s.hauer@pengutronix.de> writes:
> Hi,
> 
> > On Tue, Jun 21, 2011 at 11:46:35AM +0200, Arnaud Patard wrote:
> >> <Dinh.Nguyen@freescale.com> writes:
> >> 
> >> Hi,
> >> 
> >> > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> >> >
> >> > Adds initial low power suspend functionality to MX51.
> >> > Supports "mem" and "standby" modes.
> >> >
> >> > Tested on mx51-babbage.
> >> >
> >> > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> >> 
> >> I fail to see this patch in imx tree. Did it get merged in some other
> >> tree ?
> >
> > Not yet. Have you tested this patch?
> >
> Yes, it works fine on my platforms.

I took this as a tested-by and applied the patch.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
