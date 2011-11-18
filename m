Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1KRQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:25:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10078 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1KRQZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:25:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Nov 2011 08:25:34 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Marc Dietrich <marvin24@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 18 Nov 2011 08:25:33 -0800
Subject: RE: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Thread-Topic: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Thread-Index: Acyl6iVz8IzhNcLGToy3I7CxdBq2YgAJE2JQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74E63@HQMAIL01.nvidia.com>
References: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74C1E@HQMAIL01.nvidia.com>
 <20111118120352.GZ19069@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20111118120352.GZ19069@tbergstrom-lnx.Nvidia.com>
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

Peter De Schrijver wrote at Friday, November 18, 2011 5:04 AM:
> On Thu, Nov 17, 2011 at 07:51:35PM +0100, Stephen Warren wrote:
> > Peter De Schrijver wrote at Thursday, November 17, 2011 8:07 AM:
> > > Convert tegra20 IRQ intialization to the GIC devicetree binding. Modify the
> > > interrupt definitions in the dts files according to
> > > Documentation/devicetree/bindings/arm/gic.txt
> > >
> > > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> >
> > tegra-harmony.dts contains an interrupts property that wasn't updated,
> > for the WM8903 codec.
> 
> But that's a GPIO interrupt no?

The interrupt line from codec to Tegra is a GPIO, yes.

But the WM8903 still has the same interrupt-parent as everything else,
since it's inherited from /interrupt-parent and doesn't define its own.
Perhaps this is a mistake?

-- 
nvpublic

