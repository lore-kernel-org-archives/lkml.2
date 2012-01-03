Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2ACXDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:03:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2152 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2ACXDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:03:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 03 Jan 2012 15:03:38 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 3 Jan 2012 15:03:30 -0800
Subject: RE: [PATCH v1 0/3] Tegra30 clockframework
Thread-Topic: [PATCH v1 0/3] Tegra30 clockframework
Thread-Index: AczJYcefELP5YqAwS0ipClByKP0MIABCY9Xw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17761F1220@HQMAIL01.nvidia.com>
References: <1325517486-22458-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1325517486-22458-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Monday, January 02, 2012 8:18 AM:
> This patchset introduces the tegra30 clockframework. Clocks which require
> voltage scaling are not included in this version. The implementation doesn't
> use the generic clock code yet. It's the intention to move to it, once the
> semantics are fully clarified.

I'm not particularly familiar with Tegra's clocks, but nothing really
stood out as wrong with this patch on a quick look-through. It'd be great
if someone like Colin could look this over.

A couple thoughts below. You've probably thought about some of these
already, but I just wanted to make sure:-)

* Are we following the common clock stuff so we can move over once it's
ready?

* Are Tegra20 and Tegra30 so different we can't re-use any of the code
in tegra2_clocks.c for Tegra30?

* The device names in the peripheral clock table might benefit from a
review to make sure they match tegra2_clocks.c for the drivers we've
actually upstreamed at least.

-- 
nvpublic

