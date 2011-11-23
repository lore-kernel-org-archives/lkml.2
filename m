Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1KWMU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:20:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51564 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196Ab1KWMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:20:25 -0500
Date: Wed, 23 Nov 2011 12:20:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Marc Vertes <marc.vertes@sigfox.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123122018.GA12227@opensource.wolfsonmicro.com>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173227.GK6624@sirena.org.uk>
 <20111122184051.GA30941@pengutronix.de>
 <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com>
 <20111123104926.GB4063@pengutronix.de>
 <20111123121329.GM23376@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123121329.GM23376@infomag.iguana.be>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 01:13:29PM +0100, Wim Van Sebroeck wrote:

> Bottom line: Yes, there is hardware available that can only be pinged
> and not be stopped, but No, Userspace needs the start/stop and ping
> functionality so that a watchdog daemon can work correctly (which is
> important because some watchdog daemons also do application testing.

Right, but if the hardware doesn't support this functionality it seems
better to have the core deal with this rather than requiring the driver
to implement empty operations.
