Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2LTAyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:54:14 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38660 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2LTAyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:54:04 -0500
MIME-Version: 1.0
In-Reply-To: <20121219171423.GW4985@opensource.wolfsonmicro.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com> <20121219123201.B636A3E0AD7@localhost>
 <20121219171423.GW4985@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 00:53:43 +0000
X-Google-Sender-Auth: rimdPiCmYm8GLiWRVU6NX4hbkeU
Message-ID: <CACxGe6uoWSD4EK+jb4Hrh0-nF+waWNh8MyBH5M7oxrwA7uGLrg@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration implementation
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Simon Glass <sjg@chromium.org>, grundler@chromium.org,
        naveen@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 5:14 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 19, 2012 at 12:32:01PM +0000, Grant Likely wrote:
>
>> I'm not convinced on the design of this protocol. It won't scale beyond
>> 2 bus masters and it seems very specific to the design of a specific
>> piece of hardware. I don't think it is mature enough to bake into the
>
> I ought to point out that the original patch would've baked this into
> the Samsung I2C driver but I asked for it to be split out as it's
> nothing to do with the controller really and I'm sure I've seen it
> before.

Indeed, baking it into the driver is also the wrong abstraction.

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
