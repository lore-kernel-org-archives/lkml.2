Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0FUFKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:10:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57306 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0FUFKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:10:11 -0400
Date: Mon, 21 Jun 2010 07:09:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: gpiolib and sleeping gpios
Message-ID: <20100621050957.GA23094@pengutronix.de>
References: <4C1E88AE.5070808@bluewatersys.com> <887171.45295.qm@web180307.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <887171.45295.qm@web180307.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 20, 2010 at 07:40:46PM -0700, David Brownell wrote:
> > > And they will trigger runtime warnings, and
> > > thus eventually get fixed.
> > \
> >   }
> > 
> >   err = gpio_request(some_gpio, "some_gpio",
> >           GPIOF_NO_SLEEP);
> 
> 
> NAK ... keep it simple.  Such flags are
> clearly not necessary...
> 
> I understand that some folk are bothered
> by concepts/frameworks that seem "too simple"
> and thus want to complexify them.  In this
> case I am in a position to help avoid that.
> Complexity is not a virtue.
I'm against such an additional flag, too.  But I still think merging
gpio_get_value and gpio_get_value_cansleep is nice.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
