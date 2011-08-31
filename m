Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1HaRhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:37:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9600 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab1HaRhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:37:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Aug 2011 10:36:59 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Date: Wed, 31 Aug 2011 10:36:57 -0700
Subject: RE: [PATCH 3/3] arm/dt: Tegra: Add support-bit to SDHCI nodes
Thread-Topic: [PATCH 3/3] arm/dt: Tegra: Add support-bit to SDHCI nodes
Thread-Index: AcxnSXX71eWKx1WmSQ2TXXqBuJ2JlgAuvD5Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B327A03A@HQMAIL01.nvidia.com>
References: <1314731837-6985-1-git-send-email-swarren@nvidia.com>
 <1314731837-6985-3-git-send-email-swarren@nvidia.com>
In-Reply-To: <1314731837-6985-3-git-send-email-swarren@nvidia.com>
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

Stephen Warren wrote at Tuesday, August 30, 2011 1:17 PM:
> For Seaboard's internal eMMC, this makes the difference between a
> 5.5MB/s and 10.2MB/s transfer rate. On Harmony, there wasn't any
> measurable difference on my cheap/slow ~2MB/s card.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Grant, when applying this patch, could you possibly fix the typo in the
patch subject; s/support-bit/support-8bit/. Thanks!

-- 
nvpublic

