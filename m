Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab0JANUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:20:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0JANUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:20:05 -0400
Date: Fri, 1 Oct 2010 15:19:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Message-ID: <20101001131955.GP784@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de> <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de> <20101001104250.GB3064@sortiz-mobl> <20101001110233.GG784@pengutronix.de> <20101001130600.GD3064@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101001130600.GD3064@sortiz-mobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samuel,

> > This will be removed when all other drivers are converted together
> > with (e.g.) include/mfd/mc13783.h.
> It would be nice to have them ready for the next merge window, and I suppose
> this should go through my tree then.
If next window mean the one that opens after 2.6.37-rc1 then I'm not
sure I will manage that.  I planned to do that for the 2.6.38-rc1 window
though.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
