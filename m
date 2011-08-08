Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab1HHO0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:26:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4744 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1HHO0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:26:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Aug 2011 07:26:03 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 8 Aug 2011 07:26:00 -0700
Subject: RE: [PATCH 2/2] arm/tegra: Delete irq_to_gpio
Thread-Topic: [PATCH 2/2] arm/tegra: Delete irq_to_gpio
Thread-Index: AcxUjmvREriwIo85RYWFh2cLf2cxAABSFmyQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F172168@HQMAIL01.nvidia.com>
References: <1312582534-10871-1-git-send-email-swarren@nvidia.com>
 <1312582534-10871-2-git-send-email-swarren@nvidia.com>
 <20110806174519.GB31966@ponder.secretlab.ca>
In-Reply-To: <20110806174519.GB31966@ponder.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote at Saturday, August 06, 2011 11:45 AM:
> On Fri, Aug 05, 2011 at 04:15:34PM -0600, Stephen Warren wrote:
> > irq_to_gpio is deprecated and in the process of being removed. Make that
> > happen now for ARM Tegra.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Applied both.  Thanks.

Didn't you want an Ack by a Tegra maintainer first?

I assume they were both applied to gpio-next (although a fresh fetch  of that
doesn't show the commits)

> > I assume this will go into one of arm-soc.git's branches, but it depends
> > on the previous patch in this series to compile. Arnd, I see you already
> > have Grant's gpio/next tree in your repo as depends/gpio, so I assume
> > you'll just pick up and merge the latest version of Grant's tree before
> > applying this patch?
> >
> > Both patches compiled with a number of Tegra boards enable and tested on
> > Harmony. All without Device Tree support.
> >
> >  arch/arm/mach-tegra/include/mach/gpio.h |    8 --------
> >  1 files changed, 0 insertions(+), 8 deletions(-)

-- 
nvpublic

