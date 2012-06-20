Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2FTMoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:44:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14270 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2FTMo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:44:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 05:41:43 -0700
From: Bandi Krishna Chaitanya <bandik@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 18:14:24 +0530
Subject: RE: [PATCH V2] ARM: tegra: apbio access using dma for tegra20 only
Thread-Topic: [PATCH V2] ARM: tegra: apbio access using dma for tegra20 only
Thread-Index: Ac1O4V73841E9v/4SZq9TkVm3OCWDQAAKKbg
Message-ID: <4B31D3FCDA299E46AB481AFD049E47C97D8A45C1B9@BGMAIL01.nvidia.com>
References: <1340195794-26571-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340195794-26571-1-git-send-email-ldewangan@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2012 06:06 PM, Chaitanya Bandi wrote:
> 
> The Tegra20 HW issue with accessing APBIO registers (such as fuse registers)
> directly from the CPU concurrently with APB DMA accesses has been fixed in
> Tegra30 and later chips.
> 
> Access these registers directly from the CPU on Tegra30 and later, and apply
> the workaround only for Tegra20.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>

Tested-by: Chaitanya Bandi <bandik@nvidia.com>
Tested on Harmony with non-dt booting and confirmed that it is using the
dma based apbio access.



