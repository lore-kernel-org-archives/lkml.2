Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2HFPmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:42:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50651 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2HFPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:42:22 -0400
Date: Mon, 6 Aug 2012 16:42:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] driver: misc: bmp085: remove "of_match_table" property.
Message-ID: <20120806154214.GC29272@sirena.org.uk>
References: <1344245324-16704-1-git-send-email-sourav.poddar@ti.com>
 <20120806093033.GH17551@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806093033.GH17551@arwen.pp.htv.fi>
X-Cookie: Oatmeal raisin.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 12:30:34PM +0300, Felipe Balbi wrote:
> On Mon, Aug 06, 2012 at 02:58:44PM +0530, Sourav Poddar wrote:
> > There is an automatic binding done for I2C devices in the of_i2c core
> > code. So, DT will be able to bind to any I2C device using the
> > already existing table: MODULE_DEVICE_TABLE(i2c, bmp085_id).

> Acked-by: Felipe Balbi <balbi@ti.com>

It's good practice to have an explict compatible string even if the
default happens to work in order to avoid any name clashes.
