Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2K0NeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:34:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38529 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2K0NeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:34:10 -0500
Date: Tue, 27 Nov 2012 13:34:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linus.walleij@stericsson.com, arnd@arndb.de,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: bu21013_ts - Request a regulator that
 actually exists
Message-ID: <20121127133404.GA13065@sirena.org.uk>
References: <1354021990-16978-1-git-send-email-lee.jones@linaro.org>
 <1354021990-16978-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354021990-16978-2-git-send-email-lee.jones@linaro.org>
X-Cookie: Whistler's mother is off her rocker.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 01:13:08PM +0000, Lee Jones wrote:
> Currently the BU21013 Touch Screen driver requests a regulator by the
> name of 'V-TOUCH', which doesn't exist anywhere in the kernel. The
> correct name, as referenced in platform regulator code is 'avdd'. Here,
> when we request a regulator, we use the correct name instead.

The regulator should be requested using whatever the name for the supply
in the datasheet - AVDD does sound very pluasible but it'd be good to
check.
