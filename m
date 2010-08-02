Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0HBMwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:52:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54986 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0HBMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:52:36 -0400
Date: Mon, 2 Aug 2010 14:52:34 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tejun Heo <tj@kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 2/2] hwmon/mc13783-adc: don't access struct mc13783
	directly
Message-ID: <20100802125234.GB13900@pengutronix.de>
References: <1280740459-11500-1-git-send-email-u.kleine-koenig@pengutronix.de> <1280740459-11500-2-git-send-email-u.kleine-koenig@pengutronix.de> <20100802100455.GC3334@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100802100455.GC3334@sortiz-mobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:04:56PM +0200, Samuel Ortiz wrote:
> Hi Uwe,
> 
> On Mon, Aug 02, 2010 at 11:14:18AM +0200, Uwe Kleine-König wrote:
> > There is a shiny new mc13783 API function that can be used instead.
> > 
> > While at it refactor the code a bit to reduce code duplication a bit.
> > 
> > This removes the last user of <linux/mfd/mc13783-private.h> and so this
> > include file can go away.
> That's correct, patch applied.
> As I said, we can now move mc13783-private.h to drivers/mfd/
Actually I'd fold it into mc13783-core.c.

And I didn't do it at once because I didn't expect you to take the hwmon
change via your tree.  Will send a patch later.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
