Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2K2Qe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:34:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34811 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2K2Qe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:34:56 -0500
Date: Thu, 29 Nov 2012 16:34:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-i2c@vger.kernel.org, grundler@chromium.org, sjg@chromium.org,
        naveen@chromium.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c-s3c2410: Add bus arbitration implementation
Message-ID: <20121129163448.GA3761@sirena.org.uk>
References: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
 <1354165536-18529-3-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354165536-18529-3-git-send-email-ch.naveen@samsung.com>
X-Cookie: RHAPSODY in Glue!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:35:35AM +0530, Naveen Krishna Chatradhi wrote:

> The arbitrator is a general purpose function which uses two GPIOs to
> communicate with another device to claim/release a bus. We use it to
> arbitrate an i2c port between the AP and the EC.

Should this not be layerd on top of the I2C controller rather than part
of the controller driver?  It doesn't seem terribly controller specific.
