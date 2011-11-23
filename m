Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1KWLut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:50:49 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:48819 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753314Ab1KWLus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:50:48 -0500
Date: Wed, 23 Nov 2011 12:43:41 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: w.sang@pengutronix.de
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, HaraldWelte@viatech.com,
        broonie@opensource.wolfsonmicro.com
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <4eccdc6d.wleutgRbV7hZJdby%marc.vertes@sigfox.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173227.GK6624@sirena.org.uk>
 <20111122184051.GA30941@pengutronix.de>
 <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com>
 <20111123104926.GB4063@pengutronix.de>
In-Reply-To: <20111123104926.GB4063@pengutronix.de>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15883632937543517999
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

Wolfram Sang <w.sang@pengutronix.de> wrote:

> (BTW I removed a few duplicates from the CC list)
Yes, thanks.
>
> @Wim: Would you accept drivers which can only ping a watchdog but
> neither start/stop it?
>
> @Marc: If he does, would you be interested in updating the watchdog-core
> so that no start()/stop() will also be accepted if there is a ping()?
>
Yes, it looks reasonable to me. Watchdogs settable by BIOS only and not
cancelable (as VIA) are simple hard watchdogs for which ping() is the
only necessary operation. I'm preparing a new update.

Regards,
--
Marc
