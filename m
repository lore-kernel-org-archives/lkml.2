Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1LHR6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:58:01 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13439 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1LHR57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:57:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 08 Dec 2011 09:57:39 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Gary King <gking@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 8 Dec 2011 09:57:33 -0800
Subject: RE: [PATCH v6 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Topic: [PATCH v6 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Thread-Index: Acy1p06f6odr0fXqRtihI43ie+47dwAKzeiA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77A7E@HQMAIL01.nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
 <1323348254-29072-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1323348254-29072-5-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, December 08, 2011 5:44 AM:
> This patch splits the early init code in a common and a tegra20 specific part.
> L2 cache initialization is generalized and discovers the cache associativity
> at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
> the system using the PMC reset feature rather then the CAR system reset.

This one really should be at least 3 separate patches:
* s/tegra_init_early/tegra20_init_early/ in machine descriptions
* Switch reset mechanism from CAR to PMC
* tegra_init_cache modifications
* Not sure if all the ifdef additions go in the above, or if some should be
  separate?

Still, I think it's probably OK to go in as it is even if it isn't optimal.

-- 
nvpublic

