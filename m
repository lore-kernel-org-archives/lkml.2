Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1HOQPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:15:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8521 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab1HOQPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:15:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 15 Aug 2011 09:15:23 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Aug 2011 09:15:20 -0700
Subject: RE: [RFC PATCH 05/12] arm/dt: Tegra: Add nvidia,gpios property to
 GPIO controller
Thread-Topic: [RFC PATCH 05/12] arm/dt: Tegra: Add nvidia,gpios property to
 GPIO controller
Thread-Index: AcxaUA/ZcfiIEoF3Rcqlxz8oWUD+GABFg1Mw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25057@HQMAIL01.nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
	<1313189697-21287-6-git-send-email-swarren@nvidia.com>
 <CAOesGMj8firxDz-kqkh=jwsbC_QRW+YSFpf7dh3WaOhseCg91w@mail.gmail.com>
In-Reply-To: <CAOesGMj8firxDz-kqkh=jwsbC_QRW+YSFpf7dh3WaOhseCg91w@mail.gmail.com>
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

Olof Johansson wrote at Sunday, August 14, 2011 1:02 AM:
> On Fri, Aug 12, 2011 at 3:54 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Add board-specific gpio node for Harmony and Seaboard. This lists the
> > GPIOs used by the board. Note that not all GPIOs that exist on the board
> > are listed; only those used by devices currently supported by device
> > tree.
> 
> I don't want to bikeshed over this, but something like
> "nvidia,enabled-gpios" could be a bit more descriptive. Either way is
> OK though.

Yes, that's a much better name.

Existing board files do have a Boolean enabled/disabled flag per GPIO,
which is currently always true,  whereas this patch series only implements
"enabled" entries. I thought about it briefly, and didn't think that
explicitly disabling GPIOs that the bootloader had already enabled was
likely to be useful. Do you agree? Possibly not since IIRC you added the
tables that contain that Boolean.

> The property should be documented under the bindings Documentation/
> hierarchy though.

Yup. The next posting will include this.

-- 
nvpublic

