Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1BAQr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:47:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43677 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1BAQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:47:28 -0500
Date: Tue, 1 Feb 2011 17:47:05 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, B02280@freescale.com,
        liu.y.victor@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110201164705.GG1147@pengutronix.de>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
 <20110201105127.GA10128@sortiz-mobl>
 <20110201105909.GS9041@pengutronix.de>
 <20110201114453.GC10128@sortiz-mobl>
 <20110201115125.GE31216@n2100.arm.linux.org.uk>
 <87wrlkyn3s.fsf@lechat.rtp-net.org>
 <20110201125129.GA2027@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201125129.GA2027@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 01:51:29PM +0100, Sascha Hauer wrote:
> On Tue, Feb 01, 2011 at 01:07:35PM +0100, Arnaud Patard wrote:
> > Hi,
> > 
> > Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > 
> > > On Tue, Feb 01, 2011 at 12:44:54PM +0100, Samuel Ortiz wrote:
> > >> Ok, so would moving it do drivers/video/ make sense ?
> > >
> > > Isn't that for framebuffer drivers?
> > 
> > For now, the ipu driver is used for framebuffer on imx5.
> 
> But it will hopefully be used for camera aswell.
> 
> How about arch/arm/plat-mxc?
I'm sure Linus would object.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
