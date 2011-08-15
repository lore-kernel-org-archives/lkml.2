Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1HOQDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:03:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16220 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1HOQDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:03:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 15 Aug 2011 09:03:05 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 15 Aug 2011 09:03:03 -0700
Subject: RE: [RFC PATCH 12/12] arm/tegra: Remove temporary gpio/pinmux
 registration workaround
Thread-Topic: [RFC PATCH 12/12] arm/tegra: Remove temporary gpio/pinmux
 registration workaround
Thread-Index: AcxbPFuVup/mfTRMRz2IO4LLb5aA7AAKAosw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25053@HQMAIL01.nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
 <1313189697-21287-13-git-send-email-swarren@nvidia.com>
 <4E48FF29.1030208@ru.mvista.com>
In-Reply-To: <4E48FF29.1030208@ru.mvista.com>
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

Sergei Shtylyov wrote at Monday, August 15, 2011 5:13 AM:
> Hello.
> 
> On 13-08-2011 2:54, Stephen Warren wrote:
> 
> > This reverts commit "arm/tegra: Prevent duplicate gpio/pinmux pdev
> 
>     Would be good to also include the commit ID for gitweb.

I can't do that yet, because the commit that's being reverted is earlier
in the patch series being posted, and hence doesn't have a commit ID that
will be valid in any upstream repository.

I suppose this is the last commit in the series though, so I could remove
it and submit the revert separately once the rest is upstream.

> > registration with dt"; board-dt.c no long calls harmony/
> > seaboard_pinmux_init(), so the workaround is no longer needed.
> 
> > Signed-off-by: Stephen Warren<swarren@nvidia.com>
> 
> WBR, Sergei

-- 
nvpublic

