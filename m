Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1IVQcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:32:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10403 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1IVQcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:32:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 22 Sep 2011 09:31:49 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Thu, 22 Sep 2011 09:31:48 -0700
Subject: RE: [PATCH 1/3] arm/tegra: Move EN_VDD_1V05_GPIO to board-harmony.h
Thread-Topic: [PATCH 1/3] arm/tegra: Move EN_VDD_1V05_GPIO to board-harmony.h
Thread-Index: Acx4/09E/atAVuf2S9a3x4b5t4cqZgARaUmg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1739554CBD@HQMAIL01.nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
 <CAOesGMisOtEQpcS-hHi-3brpYzJr-UiB6b71c+bwkesPDk9iuA@mail.gmail.com>
 <20110922081140.GH17169@n2100.arm.linux.org.uk>
In-Reply-To: <20110922081140.GH17169@n2100.arm.linux.org.uk>
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

Russell King - ARM Linux wrote at Thursday, September 22, 2011 2:12 AM:
> On Wed, Sep 21, 2011 at 01:16:49PM -0700, Olof Johansson wrote:
> > Works for me. Or I could stage it in a topic branch that would be
> > merged after Russell's GPIO tree.
> 
> Holding stuff off from being merged doesn't work.

Russell,

So I take it I should add the two ack'd patches to the ARM patch system,
and have you pick them up?

Thanks.

> If you have the following commit structure:
> 
> A---...-----M1-B-C-M2
> +---A1-B1-C1'     /
> +-A2-B2-C2-------'
> 
> Now, lets say A2 depends on C1.  Merely delaying the stuff so that M2
> happens after M1 is insufficient to ensure git state doesn't break.
> When bisecting, its entirely possible that the bisect algorithm may
> chose B2 as a potential test candidate.  At that point you end up with
> A2, but without C1.
> 
> The only way to solve this is to have A2 following on from C1 - which
> of course requires A1..C1 to be declared stable and either pulled into
> your local tree or for A2..C2 to be submitted to the same tree which
> A1..C1 are already in.

-- 
nvpupblic

