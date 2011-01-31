Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1AaWs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:48:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12211 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1AaWsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:48:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 31 Jan 2011 14:48:52 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@android.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "mike@compulab.co.il" <mike@compulab.co.il>,
        "gadiyar@ti.com" <gadiyar@ti.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 31 Jan 2011 14:48:50 -0800
Subject: RE: [PATCH] [ARM] tegra: Add i2c support
Thread-Topic: [PATCH] [ARM] tegra: Add i2c support
Thread-Index: AQLW3V55jFGZK66mb0dzj8jvNYd76wKBETkpkcFt+TA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0310C8E2E6@HQMAIL01.nvidia.com>
References: <1283466103-20889-1-git-send-email-ccross@android.com>
 <AANLkTimYURYGix-0Xk3wdf1A-XEAJbBXR_JDn1BFw_uq@mail.gmail.com>
In-Reply-To: <AANLkTimYURYGix-0Xk3wdf1A-XEAJbBXR_JDn1BFw_uq@mail.gmail.com>
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

Colin Cross wrote at Tuesday, December 21, 2010 5:12 PM:
> 
> On Thu, Sep 2, 2010 at 3:21 PM, Colin Cross <ccross@android.com> wrote:
> > Signed-off-by: Colin Cross <ccross@android.com>
> > ---
> >  drivers/i2c/busses/Kconfig     |    7 +
> >  drivers/i2c/busses/Makefile    |    1 +
> >  drivers/i2c/busses/i2c-tegra.c |  665 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/i2c-tegra.h      |   25 ++
> >  4 files changed, 698 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/busses/i2c-tegra.c
> >  create mode 100644 include/linux/i2c-tegra.h
> >
> Ben, this didn't make it into 2.6.37?  Can it go into next-i2c?

I didn't see any response to this request, at least not in the linux-tegra
archives.

-- 
nvpublic

