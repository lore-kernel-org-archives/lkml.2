Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1B1Kbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:31:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59528 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1B1Kbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:31:31 -0500
Date: Mon, 28 Feb 2011 11:31:24 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-embedded@vger.kernel.org
Subject: Re: [GIT PULL] Generic PWM Device API
Message-ID: <20110228103124.GI29521@pengutronix.de>
References: <AANLkTi=rxzrnt0QZQPJFRboSW_Fyt6zQ5S9KD4Lp=hnU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=rxzrnt0QZQPJFRboSW_Fyt6zQ5S9KD4Lp=hnU@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:20:33 up 11 days, 22:17, 28 users,  load average: 1.85, 1.35,
 1.15
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:38:38PM -0600, Bill Gatliff wrote:
> Andrew, Linus:
> 
> 
> The git repository described in the following pull request implements
> a generic PWM device driver API.  This API is intended to eventually
> supercede the existing PWM device drivers, but during a migration
> period will coexist peacefully with them.

Sorry for the late answer, but it took some time to read the patches
again.

Is it a good idea to have to APIs for the same thing in the kernel?
The old API has users whereas the new API has none. How can we migrate
from one API to the other when for example the backlight pwm driver
depends on the old API, SoC level drivers implement the old API, but
the atmel pwm driver is only available for the new API?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
