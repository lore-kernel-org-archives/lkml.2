Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1KWOrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:47:00 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:33083 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1KWOq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:46:57 -0500
Date: Wed, 23 Nov 2011 15:46:53 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: wim@iguana.be, broonie@opensource.wolfsonmicro.com
Cc: w.sang@pengutronix.de, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, HaraldWelte@viatech.com
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173227.GK6624@sirena.org.uk>
 <20111122184051.GA30941@pengutronix.de>
 <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com>
 <20111123104926.GB4063@pengutronix.de>
 <20111123121329.GM23376@infomag.iguana.be>
 <20111123122018.GA12227@opensource.wolfsonmicro.com>
 <20111123124037.GN23376@infomag.iguana.be>
In-Reply-To: <20111123124037.GN23376@infomag.iguana.be>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 530580333029738287
X-Ovh-Remote: 92.103.90.130 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrtdehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuc
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck <wim@iguana.be> wrote:

> Hi Marc,
>
> Coming back to now: if the driver incorporates the timer (like all other
> devices that can be started but not stopped once started do), then the start
> and stop functions are not empty.
> The timer (with the example that I prepared as part of the generic code) is
> not so difficult and will be a good solution for the time being. (Unless
> Dmitry Artamonow's comment about the fact that the watchdog could perhaps
> be started and stopped is correct... This should be investigated first imho).
>
The watchdog can not be started and stopped from the driver. This is
what I investigated first and found impossible (and explains why this
driver is still missing).

I do not fully understand yet what has to be done with the timer.

Regards,
--
Marc
