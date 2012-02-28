Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2B1OcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:32:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44132 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2B1OcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:32:20 -0500
Date: Tue, 28 Feb 2012 14:32:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/3] mfd: Add basic support for the Congatec CGEB BIOS
 interface
Message-ID: <20120228143217.GB25472@sirena.org.uk>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
 <1328102793-4313-2-git-send-email-s.hauer@pengutronix.de>
 <20120220163927.GY5387@sortiz-mobl>
 <20120220180752.GV3852@pengutronix.de>
 <20120227135827.GM27687@sortiz-mobl>
 <20120227172443.GD3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227172443.GD3852@pengutronix.de>
X-Cookie: Non-sequiturs make me eat lampshades.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:24:43PM +0100, Sascha Hauer wrote:
> On Mon, Feb 27, 2012 at 02:58:27PM +0100, Samuel Ortiz wrote:

> > Yes, this seems to be the trend apparently. Could you try pushing that into
> > the x86/platform, please ? If they put you under fire, I guess I could take
> > this patchset. But they have several "BIOS interfaces" there already...

> Ok, I'll put on my asbestos suit and give it a try.

You might want to jump into the thread Linus Walleij started about
system controllers today.
