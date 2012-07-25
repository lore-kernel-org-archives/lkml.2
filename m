Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2GYGvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:51:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7599 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2GYGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:51:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Jul 2012 23:51:00 -0700
Message-ID: <500F94D1.5090703@nvidia.com>
Date: Wed, 25 Jul 2012 12:10:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
References: <20120725111855.bd9553a735807afa0bd03821@canb.auug.org.au>
In-Reply-To: <20120725111855.bd9553a735807afa0bd03821@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2012 06:48 AM, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>
> Hi Samuel,
>
> Today's linux-next merge of the mfd tree got a conflict in
> arch/arm/configs/tegra_defconfig between commit dbebe1589d3a ("ARM:
> tegra: defconfig updates") from Linus' tree and commit 05f3ad2b8ae5
> ("ARM: tegra: defconfig: Enable tps6586x gpio") from the mfd tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
Yes, this fix is proper.

Thanks,
Laxman
