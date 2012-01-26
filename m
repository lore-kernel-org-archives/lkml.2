Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2AZUpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:45:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14059 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2AZUpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:45:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Jan 2012 12:45:11 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 12:44:45 -0800
Subject: RE: [PATCH v1 8/8] ARM: tegra: support for secondary cores on
 Tegra30
Thread-Topic: [PATCH v1 8/8] ARM: tegra: support for secondary cores on
 Tegra30
Thread-Index: AczcTSojqjFirnaYSFi0erbpYX7mHgAHbr9g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB8247E@HQMAIL01.nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
 <1327597641-7519-9-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1327597641-7519-9-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, January 26, 2012 10:07 AM:
> Add support for bringing up secondary cores on Tegra30. On Tegra30 secondary
> CPU cores are powergated, so we need to turn on the domains before we can bring
> the CPU cores online. Bringing secondary cores online happens early during the
> ssytem boot, so we call powergating initialization from platform early_init
> function.
> 
> Based on work by:
> 
> Scott Williams <scwilliams@nvidia.com>
> Colin Cross <ccross@android.com>
> Alex Frid <afrid@nvidia.com>
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

The series,

Acked-by: Stephen Warren <swarren@nvidia.com>

(I already saw this a few times before Peter posted it, so any concerns
I had have been fixed. Still, I'm not very familiar with this part of
the code, so it'd be awesome if e.g. Colin could review this too)

Tested-by: Stephen Warren <swarren@nvidia.com>

(Booted Tegra20 Harmony, validated 2 CPUs found in dmesg during boot,
validated top showed 2 CPUs being actively used. Booted Tegra30 Cardhu,
validated 4 CPUs found in dmesg during boot, but didn't validate anything
from user-space since the SD controller doesn't work yet and I don't have
an initrd set up to test with).

-- 
nvpublic

