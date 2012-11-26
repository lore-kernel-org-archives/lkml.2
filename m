Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2KZGrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:47:25 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13124 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2KZGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:47:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 25 Nov 2012 22:47:23 -0800
Message-ID: <50B31079.5060309@nvidia.com>
Date: Mon, 26 Nov 2012 12:17:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the regulator tree with the mfd tree
References: <20121126164412.653f0cb43bb55775475f6ed3@canb.auug.org.au>
In-Reply-To: <20121126164412.653f0cb43bb55775475f6ed3@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 November 2012 11:14 AM, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>
> Hi all,
>
> Today's linux-next merge of the regulator tree got a conflict in
> include/linux/mfd/tps65090.h between commit 3863db3e800c ("mfd: tps65090:
> Remove unused member of struct tps65090") from the mfd tree and commit
> 24282a1ca33b ("regulator: tps65090: Register all regulators in single
> probe call") from the regulator tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary (no action
> is required).
>

The merges looks fine.
