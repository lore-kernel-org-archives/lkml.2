Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1HWS1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:27:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9674 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1HWS1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:27:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Aug 2011 11:27:14 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-i2c@fluff.org>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 23 Aug 2011 11:27:12 -0700
Subject: RE: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
	empty of_get_property for non-dt)
Thread-Topic: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
	empty of_get_property for non-dt)
Thread-Index: AcxYiW0+Eckdj+oRSvyjfS+mlpxbwgAqSq7QAiOrJfA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A38CA@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF04A0687289@HQMAIL01.nvidia.com>
 <20110812004732.GF19115@trinity.fluff.org>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA24F41@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24F41@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Friday, August 12, 2011 3:09 PM:
...
> Related, here's the list of outstanding patches for i2c-tegra.c that I'm
> aware of:
> 
> [PATCH] i2c: Tegra: Add of_match_table
> http://www.spinics.net/lists/linux-i2c/msg05898.html
> 
> [PATCH] i2c: tegra: add I2C_FUNC_SMBUS_EMUL to adapter functionality
> http://www.spinics.net/lists/linux-i2c/msg05396.html
> 
> [PATCH] i2c: tegra: fix possible race condition after tx
> http://www.spinics.net/lists/linux-i2c/msg06103.html
> 
> Hope this helps! Thanks.

Ben,

I see the patches above aren't in linux-next yet. I'd love to get them
queued up so they get into 3.2. Can you please apply them? At least the
second of these was first posted over 4 months ago.

Thanks very much!

-- 
nvpublic

