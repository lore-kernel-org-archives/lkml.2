Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2K1QbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:31:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37289 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2K1QbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:31:14 -0500
Date: Wed, 28 Nov 2012 16:31:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 3/3] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121128163105.GA28698@sirena.org.uk>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-4-git-send-email-lee.jones@linaro.org>
 <20121128070332.GC23378@core.coreip.homeip.net>
 <20121128085731.GH2013@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128085731.GH2013@gmail.com>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:57:31AM +0000, Lee Jones wrote:

> > I applied these 3 patches, but for DT we also need to specify compatible
> > ID and set up of_match_table pointer. 

> Why do you need a compatible string?

The I2C subsystem guesses at a compatible string by default but it's
much better to explicitly set one as conflicts do arise from time to
time (eg, Wolfson parts are called WMxxxx but the WM prefix is also used
by at least WonderMedia).
