Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1EFIZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 04:25:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1EFIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 04:25:34 -0400
Date: Fri, 6 May 2011 10:25:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] leds: provide helper to register "leds-gpio" devices
Message-ID: <20110506082524.GR11574@pengutronix.de>
References: <1302097097.22904.41.camel@rex>
 <1302554157-24145-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110426150815.GY31131@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110426150815.GY31131@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, Apr 26, 2011 at 05:08:15PM +0200, Uwe Kleine-König wrote:
> On Mon, Apr 11, 2011 at 10:35:57PM +0200, Uwe Kleine-König wrote:
> > This function makes a deep copy of the platform data to allow it to live
> > in init memory.
> > The definition cannot go into leds-gpio.c because it needs to be builtin
> > to be usable by platforms.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> any comment by you?
ping

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
