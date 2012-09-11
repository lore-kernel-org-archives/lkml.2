Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab2IKK2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:28:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11857 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2IKK2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:28:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 11 Sep 2012 03:20:17 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: Bill Huang <bilhuang@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Xin Xie <xxie@nvidia.com>, "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "jhovold@gmail.com" <jhovold@gmail.com>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Sep 2012 18:25:14 +0800
Subject: RE: [PATCH v2 0/2] mfd: dt: add power off support for
 Tegra20/Tegra30
Thread-Topic: [PATCH v2 0/2] mfd: dt: add power off support for
 Tegra20/Tegra30
Thread-Index: Ac1+cEgJeSvXrRFZTD+yGiMaCzJ5mQRly+2Q
Message-ID: <A7051F87A141B744BCAF487D48E5B3BDF5BBE83B1A@HKMAIL02.nvidia.com>
References: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1345424876-4365-1-git-send-email-bilhuang@nvidia.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, 

Could somebody review this?

Thanks,
Bill

> 
> This patch series add new property into regulator DT for telling whether or not to hook pmic's power off routine to system call
> "pm_power_off".
> 
> Patch 1 add power off support for Tegra20 boards using TPS6586x Patch 2 add power off support for Tegra30 boards using TPS65910
> 
> Verified on Seaboard (Tegra20) and Cardhu (Tegra30)
> 
> V2:
> * Take multiple pmic instances into consideration while assigning global variables
>   as per suggestion from Thierry Reding <thierry.reding@avionic-design.de>
> 
> V1:
> * Based on master branch of sameo/mfd-2.6.git
> 
> Bill Huang (2):
>   mfd: dt: tps6586x: Add power off control
>   mfd: dt: tps65910: add power off control
> 
>  Documentation/devicetree/bindings/mfd/tps65910.txt |    4 +++
>  .../devicetree/bindings/regulator/tps6586x.txt     |    6 +++++
>  drivers/mfd/tps6586x.c                             |   19 +++++++++++++++++
>  drivers/mfd/tps65910.c                             |   22 ++++++++++++++++++++
>  include/linux/mfd/tps6586x.h                       |    1 +
>  include/linux/mfd/tps65910.h                       |    3 ++
>  6 files changed, 55 insertions(+), 0 deletions(-)
> 
> --
> 1.7.4.1
nvpublic
