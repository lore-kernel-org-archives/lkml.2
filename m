Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab1IGTJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:09:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50073 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1IGTJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:09:46 -0400
Date: Wed, 7 Sep 2011 20:07:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <AChew@nvidia.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 1/4] i2c: Add irq_gpio field to struct i2c_client.
Message-ID: <20110907190752.GB24703@sirena.org.uk>
References: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
 <4E60985B.6010901@cam.ac.uk>
 <74CDBE0F657A3D45AFBB94109FB122FF04B327A55D@HQMAIL01.nvidia.com>
 <201109021805.27569.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109021805.27569.arnd@arndb.de>
X-Cookie: Doing gets it done.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 06:05:27PM +0200, Arnd Bergmann wrote:

> It would not fit well if we expect gpio numbers to be local to
> a gpio controller, with no unique global identifier for them, similar
> to how dma channels in the dma-engine subsystem are handled.

Or perhaps moving to a clk API style lookup?
