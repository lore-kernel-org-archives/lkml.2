Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2AJRYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:24:05 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15210 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2AJRYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:24:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 10 Jan 2012 09:23:53 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 09:23:52 -0800
Subject: RE: [PATCH] ARM: tegra: initialize basic system clocks
Thread-Topic: [PATCH] ARM: tegra: initialize basic system clocks
Thread-Index: AczPtA7K8RhZtyXwQ/CI+u4eB5lSEAACEjOg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A404@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A286@HQMAIL01.nvidia.com>
 <1326212538-15419-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1326212538-15419-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Tuesday, January 10, 2012 9:22 AM:
> Initialize basic system clocks and provide a auxdata table to allow some
> peripheral drivers to find their clocks.
...
> This should fix the hang you observed when sdhci_add_host() fails.

Yes, it does. This plus the Tegra30 clock patch series you posted stops
I2C and SDHCI drivers complaining about a lack of clocks during boot,
which is a great step forwards, even if SDHCI doesn't yet initialize
successfully. Thanks.

This patch and the clock series:

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

