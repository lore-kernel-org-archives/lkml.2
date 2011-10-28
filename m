Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1J1RMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:12:01 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15887 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1J1RL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:11:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 28 Oct 2011 10:11:50 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Taylor Hutt <thutt@chromium.org>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yufeng Shen <miletus@chromium.org>
Date: Fri, 28 Oct 2011 10:11:48 -0700
Subject: RE: [PATCH] arch: arm: tegra: Enable headphone detection gpio
Thread-Topic: [PATCH] arch: arm: tegra: Enable headphone detection gpio
Thread-Index: AcyVjpOWpLijfz0rR3Oba4/PHDQF+gABZuCQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4E7@HQMAIL01.nvidia.com>
References: <1319819226-19098-1-git-send-email-thutt@chromium.org>
In-Reply-To: <1319819226-19098-1-git-send-email-thutt@chromium.org>
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

Taylor Hutt wrote at Friday, October 28, 2011 10:27 AM:
> From: Yufeng Shen <miletus@chromium.org>
> 
> Enable the headphone detection gpio on tegra platform.
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>

Aha, that explains why this seemed to have stopped working when I tried
it on Seaboard recently; I guess it never did. Harmony already does this
correctly, and that's where I must have tested the feature initially.

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

