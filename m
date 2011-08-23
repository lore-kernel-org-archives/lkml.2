Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1HWXg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:36:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2033 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1HWXgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:36:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 23 Aug 2011 16:35:56 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Date: Tue, 23 Aug 2011 16:35:52 -0700
Subject: RE: [RFC PATCH v2 11/13] arm/tegra: Add device tree support to
 pinmux driver
Thread-Topic: [RFC PATCH v2 11/13] arm/tegra: Add device tree support to
 pinmux driver
Thread-Index: AcxbxeDfLg8xJiycQRCOHBtbgY1haQGJzojw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A3A38@HQMAIL01.nvidia.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <1313440100-17131-12-git-send-email-swarren@nvidia.com>
 <20110816034509.GG8044@S2100-06.ap.freescale.net>
In-Reply-To: <20110816034509.GG8044@S2100-06.ap.freescale.net>
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

Shawn Guo wrote at Monday, August 15, 2011 9:45 PM:
> On Mon, Aug 15, 2011 at 02:28:18PM -0600, Stephen Warren wrote:
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/pinmux.c |  249 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 249 insertions(+), 0 deletions(-)
> >
> Same question here, since we are moving over to device tree anyway,
> is it necessarily to keep these "#ifdef CONFIG_OF" all over the files?
> Can we manage to get rid of them, since we have a suite of empty OF API
> created for this?

Yes, the ifdefs can all be eliminated. I'll need to add a couple other
empty functions to <linux/of.h>. I also folded the foo_probe_dt()
functions into foo_probe(), since the need for the ifdefs is gone.

-- 
nvpublic

