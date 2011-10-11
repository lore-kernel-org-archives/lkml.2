Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1JKQgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:36:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16014 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1JKQgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:36:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 11 Oct 2011 09:36:08 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 11 Oct 2011 09:36:04 -0700
Subject: RE: [PATCH v8 3/3] arm/tegra: device tree support for ventana board
Thread-Topic: [PATCH v8 3/3] arm/tegra: device tree support for ventana board
Thread-Index: AcyIAvBDJn3nVxx8RJu0S9sjBEkt6wAMJuJA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE19AB0@HQMAIL01.nvidia.com>
References: <1318329909-32601-1-git-send-email-pdeschrijver@nvidia.com>
 <1318329909-32601-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1318329909-32601-4-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Tuesday, October 11, 2011 4:45 AM:
> Change-Id: I5ed18750e6a8aa3242dae4bcd7165cfd819356d2

You probably want to remove that.

...
> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
...
> +	if (i == ARRAY_SIZE(pinmux_configs))
> +		WARN(1, "Unknown platform! Pinmuxing not initialized\n");

Sorry to keep picking on this, but shouldn't that be simply:

		WARN(i == ARRAY_SIZE(pinmux_configs),
			"Unknown platform! Pinmuxing not initialized\n");

-- 
nvpublic

