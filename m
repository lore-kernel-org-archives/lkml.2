Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1BGRpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:45:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14584 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1BGRpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:45:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Mon, 07 Feb 2011 09:45:05 -0800
From: Stephen Warren <swarren@nvidia.com>
To: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Colin Cross <ccross@android.com>
CC: "mike@compulab.co.il" <mike@compulab.co.il>,
        "gadiyar@ti.com" <gadiyar@ti.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 7 Feb 2011 09:45:01 -0800
Subject: RE: [PATCH] [ARM] tegra: Add i2c support
Thread-Topic: [PATCH] [ARM] tegra: Add i2c support
Thread-Index: AQLW3V55jFGZK66mb0dzj8jvNYd76wKBETkpkcFt+TCACqr7kA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0310F5FC90@HQMAIL01.nvidia.com>
References: <1283466103-20889-1-git-send-email-ccross@android.com>
 <AANLkTimYURYGix-0Xk3wdf1A-XEAJbBXR_JDn1BFw_uq@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Sent: Monday, January 31, 2011 3:49 PM:
> 
> Colin Cross wrote at Tuesday, December 21, 2010 5:12 PM:
> >
> > On Thu, Sep 2, 2010 at 3:21 PM, Colin Cross <ccross@android.com> wrote:
> > > Signed-off-by: Colin Cross <ccross@android.com>
> > > ---
> > >  drivers/i2c/busses/Kconfig     |    7 +
> > >  drivers/i2c/busses/Makefile    |    1 +
> > >  drivers/i2c/busses/i2c-tegra.c |  665 ++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/i2c-tegra.h      |   25 ++
> > >  4 files changed, 698 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/i2c/busses/i2c-tegra.c
> > >  create mode 100644 include/linux/i2c-tegra.h
> > >
> > Ben, this didn't make it into 2.6.37?  Can it go into next-i2c?
> 
> I didn't see any response to this request, at least not in the linux-tegra
> archives.

Ben, did Colin's latest patch look good; could it be applied?

Colin, perhaps you could repost the patch in case it's fallen out of Ben's
inbox.

As background, I'd really like this patch to show up in 2.6.39; the ASoC
driver I've upstreamed for Tegra Harmony (and which will be in 2.6.39) relies
on this I2C driver to provide communication with the audio codec. Hence, the
ASoC driver is useless without the I2C driver also merged.

Thanks.

-- 
nvpublic

