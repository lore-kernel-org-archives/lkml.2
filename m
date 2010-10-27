Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760768Ab0J0JJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:09:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46294 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760738Ab0J0JJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:09:23 -0400
Date: Wed, 27 Oct 2010 11:09:21 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
        amit.kucheria@canonical.com
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
Message-ID: <20101027090921.GB8554@pengutronix.de>
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com> <20101027082958.GA6797@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101027082958.GA6797@angua.secretlab.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 27, 2010 at 09:29:59AM +0100, Grant Likely wrote:
> > ---
> >  arch/arm/plat-mxc/include/mach/iomux-mx53.h |  301 +++++++++++++++++++
> >  arch/arm/plat-mxc/include/mach/mx53.h       |  433 +++++++++++++++++++++++++++
> 
> Hi Dinh.
> 
> In general, these definitions should not be added until they are
> actually needed by driver code.
ack.

> Also, from my understanding, the mx53 is very similar to the mx51.
> If I'm correct, then they should be sharing the same set of #defines.
Note, I asked for a seperate header file.  See
http://thread.gmane.org/gmane.linux.kernel/1051001/focus=1051352

> What is the diff between *mx51.h and *mx53.h?
Just from a quick look at least some base addresses are different.
(e.g. MX51_DEBUG_BASE_ADDRESS = 0x60000000, MX53_DEBUG_BASE_ADDRESS =
0x40000000; SPBA0, AIPS1 and AIPS2 differ, too)

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
