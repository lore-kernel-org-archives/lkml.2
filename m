Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1AaHyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:54:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38641 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1AaHyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:54:12 -0500
Date: Mon, 31 Jan 2011 08:54:08 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.miao@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Hemanth V <hemanthv@ti.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [RFC] add pwmlib support
Message-ID: <20110131075408.GH9041@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
 <4D447E5E.6060007@metafoo.de>
 <F45880696056844FA6A73F415B568C6953739F1986@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F45880696056844FA6A73F415B568C6953739F1986@EXDCVYMBSTM006.EQ1STM.local>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:51:17 up 15 days, 17:57, 14 users,  load average: 0.08, 0.04,
 0.04
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:35:33AM +0100, Arun MURTHY wrote:
> Hi Sascha,
> 
> > > I Cced the people working with PWMs in the kernel in the hope that
> > they can
> > > give input on what's missing / wrong in this implementation
> > >
> > > Sascha
> > >
> > 
> > Hi
> > 
> > There have been two other proposals for a generic PWM api during the
> > last year.
> > You might want to take a look at them.
> > 
> > https://lkml.org/lkml/2010/2/9/275
> > https://lkml.org/lkml/2010/9/28/107
> > 
> > I've added Bill Gatliff and Arun Murthy to Cc.
> > 
> 
> As said by Lars, we already have developed the pwm core driver and
> progressing towards aligning the existing pwm drivers to the pwm core
> driver.
> These set of patches are expected to be out in LKML by this week.

Nice, problem solved without me having to work on it ;). Please consider
Ccing linux-arm-kernel as many of your potential users are following this
list.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
