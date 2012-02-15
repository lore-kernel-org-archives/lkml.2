Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2BOV2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:28:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16613 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2BOV17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:27:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 15 Feb 2012 13:27:44 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Feb 2012 13:27:43 -0800
Subject: RE: [PATCH v3 00/10] Add tegra30 support for secondary cores
Thread-Topic: [PATCH v3 00/10] Add tegra30 support for secondary cores
Thread-Index: AcznhVHdlLxNnIPPSBirvu5EHMcA3gEoxVIw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178FACB954@HQMAIL01.nvidia.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, February 09, 2012 4:48 PM:
> This patchset introduces support for secondary cores on tegra30. It also
> introduces some functions for the flowcontroller and adds basic support for
> tegra30 powerdomains.

The code looks fine to me. I do notice the following when running
"shutdown -h now":

[   27.762124] SMP: failed to stop secondary CPUs

So, this patch series makes the secondary cores boot OK, but not shut
down it appears. Is that expected? It's probably something we can fix
with a following on patch rather than re-spinning this series though?

-- 
nvpublic

