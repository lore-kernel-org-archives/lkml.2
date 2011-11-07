Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1KGXEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:04:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13234 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1KGXEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:04:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 07 Nov 2011 15:03:56 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 7 Nov 2011 15:03:55 -0800
Subject: RE: [PATCH v3 0/8] Add support for tegra30 and cardhu
Thread-Topic: [PATCH v3 0/8] Add support for tegra30 and cardhu
Thread-Index: AcydWGNKXFXijC73Tn6w/d5NU1b3XgASF4dg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A525A@HQMAIL01.nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Monday, November 07, 2011 7:20 AM:
> This patchset adds support for the tegra30 SoC and the cardhu development
> board.
> 
> Pathset is on top of Will Deacon's ARM reset work.

Peter, how did you test this on Tegra30/Cardhu?

I took the branch you send me containing all your patches and built it. I
tried booting this using both our internal Tegra30 U-boot, and using
fastboot from an internal Android Honeycomb image. In both cases, as soon
as the kernel started, it spewed a line or two of binary garbage on the
serial port, then nothing. Can you fill me in on details like:

a) What .config you used
b) What kernel command-line you used
c) Do you have an A01 or A02 CPU on your Cardhu, and how much RAM?
d) What bootloader you used (exact git commit ID of U-Boot, or the 
Android build ID)
e) Do you have any local changes applied that may help boot work but aren't
in your patchset, or the branch you sent me?

Perhaps we should work on this off-list and report back once I've got it
working.

Thanks.

-- 
nvpublic

