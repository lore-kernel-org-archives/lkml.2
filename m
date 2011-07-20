Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1GTSeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:34:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12536 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1GTSeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:34:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Jul 2011 11:33:57 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Date: Wed, 20 Jul 2011 11:33:56 -0700
Subject: RE: [PATCH] arm/dt: tegra devicetree support
Thread-Topic: [PATCH] arm/dt: tegra devicetree support
Thread-Index: AcxHCtA1s+TnIuHpT2iEHfTli+kKrAAAFcpg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEEFA@HQMAIL01.nvidia.com>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
 <20110720182823.GD4642@ponder.secretlab.ca>
In-Reply-To: <20110720182823.GD4642@ponder.secretlab.ca>
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

Grant Likely wrote at Wednesday, July 20, 2011 12:28 PM:
> On Wed, Jul 20, 2011 at 08:37:19AM -0700, Stephen Warren wrote:
> > Grant Likely wrote at Tuesday, July 19, 2011 5:43 PM:
> > > Everything required to populate NVIDIA Tegra devices from the device
> > > tree.  This patch adds a new DT_MACHINE_DESC() which matches against
> > > a tegra20 device tree.  So far it only registers the on-chip devices,
> > > but it will be refined in follow on patches to configure clocks and
> > > pin IO from the device tree also.
...
> > > diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
> >
> > tegra-*.dts don't include status="disable" for all the unused controllers.
> > Should that be added?
> 
> I dropped that pattern since my preference has been to have boards
> explicitly disable unused cores and that has generally been the
> pattern on other DT platforms.

Sorry if I wasn't clear, but what I meant was that the board-specific
files tegra-harmony.dts and tegra-seaboard.dts don't include the status=
"disable" entries for the modules/ports they don't use.

Still, everything probably works OK without that...

-- 
nvpublic

