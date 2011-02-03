Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1BCN2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:28:13 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57349 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab1BCN2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:28:12 -0500
Date: Thu, 3 Feb 2011 13:28:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russ Gorby <russ.gorby@intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: intel_mid_ssp_spi: new SPI driver for intel
	Medfield platform
Message-ID: <20110203132800.GA17825@sirena.org.uk>
References: <1296680512-2758-2-git-send-email-russ.gorby@intel.com> <20110202224054.7916e7af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202224054.7916e7af@lxorguk.ukuu.org.uk>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 10:40:54PM +0000, Alan Cox wrote:

> And this is the unified one that handles all the devices, but I gather
> may need some fixing/test work on Medfield.

I've got the same question here as I had with Russ' patch: it looks like
there's some overlap with the SSP ports used for audio (it's just a
generic programmable serial port so even if it's not normally used for
audio that's a possiblity), how is that handled?
