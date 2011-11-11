Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1KKVlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:41:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17973 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KKVlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:41:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 11 Nov 2011 13:40:53 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 11 Nov 2011 13:40:48 -0800
Subject: RE: [PATCH v4 00/10] Add support for tegra30 and cardhu
Thread-Topic: [PATCH v4 00/10] Add support for tegra30 and cardhu
Thread-Index: AcygZDAphH77Z9tlSj6j7goZoUnGBwAVg85Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408058A8@HQMAIL01.nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Friday, November 11, 2011 4:22 AM:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.

Tested-by: Stephen Warren <swarren@nvidia.com>

Tested:

Tegra20-only build, Tegra30-only build, Tegra20+Tegra30 build.

Booting on Tegra30/Cardhu: Tegra30-only build, Tegra20+Tegra30 build.

Booting on Tegra20/Seaboard, using DT and board files.

All testing based on next-20111111, plus Will Deacon's 3 reset patches
that this relies on.

I haven't actually looked at the patches yet.

-- 
nvpublic

