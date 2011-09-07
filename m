Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1IGTTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:19:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51756 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab1IGTTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:19:04 -0400
Date: Wed, 7 Sep 2011 20:19:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthieu CASTET <castet.matthieu@free.Fr>
Cc: linux-kernel@vger.kernel.org, dp@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/8] regmap: Add the LZO cache support
Message-ID: <20110907191901.GC24703@sirena.org.uk>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1314978375-11539-5-git-send-email-dp@opensource.wolfsonmicro.com>
 <loom.20110905T233927-790@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20110905T233927-790@post.gmane.org>
X-Cookie: Doing gets it done.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 09:40:45PM +0000, Matthieu CASTET wrote:
> Dimitris Papastamos <dp <at> opensource.wolfsonmicro.com> writes:

Don't drop CCs from mails if you want people to actually read them.

> > This patch adds support for LZO compression when storing the register
> > cache.

> > For a typical device whose register map would normally occupy 25kB or 50kB
> > by using the LZO compression technique, one can get down to ~5-7kB.  

> Do you have example of such case ?

> Caching 25kB or 50kB looks crazy.

Audio CODECs for smartphones can easily have well over a thousand
registers (excluding things like DSP memories) connected over
rel;atively slow buses like I2C or SPI with lots of read/modify/write
cycles (so cutting out the physical read is a real win) and we want to
power them off when not in use.
