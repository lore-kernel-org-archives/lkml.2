Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1LHSIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:08:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14081 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1LHSIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:08:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 08 Dec 2011 10:08:25 -0800
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
Date: Thu, 8 Dec 2011 10:08:19 -0800
Subject: RE: [PATCH v6 00/10] Add support for tegra30 and cardhu
Thread-Topic: [PATCH v6 00/10] Add support for tegra30 and cardhu
Thread-Index: Acy1pxgc79a0UGpVSpKGoBIZu+alnwALKFYw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77A8A@HQMAIL01.nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
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
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.
> 
> Patchset is on top of linux-next and
> http://www.spinics.net/lists/linux-tegra/msg03016.html.

The series,

Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

Tested:

Two separate branches:

* next-20111208, plus the patch linked above, plus this patch series.
* My local dev branch based on next-20111206, plus all the patches I've
  posted recently, plus this patch series.

In each branch, tested the following builds:

* Non-DT build, Tegra20 only:
  - Booted Harmony, root on SD, tested audio.
* DT build, Tegra20 only:
  - Booted Harmony, root on SD, tested audio only in my dev branch.
* DT build, Tegra20 and Tegra30 support:
  - Booted Harmony, root on SD, tested audio only in my dev branch.
  - Booted Cardhu to the point of attempting to mount a root FS.
* DT build, Tegra30 support only:
  - Booted Cardhu to the point of attempting to mount a root FS

-- 
nvpublic


