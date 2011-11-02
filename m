Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab1KBSgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:36:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3999 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1KBSgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:36:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Nov 2011 11:36:39 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>, Taylor Hutt <thutt@chromium.org>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yufeng Shen <miletus@chromium.org>
Date: Wed, 2 Nov 2011 11:36:35 -0700
Subject: RE: [PATCH] arch: arm: tegra: Enable headphone detection gpio
Thread-Topic: [PATCH] arch: arm: tegra: Enable headphone detection gpio
Thread-Index: AcyVjpOWpLijfz0rR3Oba4/PHDQF+gABZuCQAP54CBA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A4777@HQMAIL01.nvidia.com>
References: <1319819226-19098-1-git-send-email-thutt@chromium.org>
 <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4E7@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4E7@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Friday, October 28, 2011 11:12 AM:
> Taylor Hutt wrote at Friday, October 28, 2011 10:27 AM:
> > From: Yufeng Shen <miletus@chromium.org>
> >
> > Enable the headphone detection gpio on tegra platform.
> >
> > Signed-off-by: Yufeng Shen <miletus@chromium.org>
> 
> Aha, that explains why this seemed to have stopped working when I tried
> it on Seaboard recently; I guess it never did. Harmony already does this
> correctly, and that's where I must have tested the feature initially.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>

I just tried testing this and noticed this patch doesn't apply to mainline;
I think the patch was lifted verbatim from the ChromeOS kernel without
being rebased onto mainline? Please rebase to mainline and repost.

But then I manually applied the patch and tested it, and it does work.

-- 
nvpublic

