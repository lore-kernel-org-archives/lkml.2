Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab2IDUrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:47:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35715 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2IDUre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:47:34 -0400
Message-ID: <504668E3.1060907@wwwdotorg.org>
Date: Tue, 04 Sep 2012 14:47:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com
CC: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] regulator: tps6586x: register regulator even if no
 init data
References: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 09:01 AM, Laxman Dewangan wrote:
> Register all TPS6586x regulators even if there is no regulator
> init data for platform i.e. without any user-supplied constraints.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Tested-by: Stephen Warren <swarren@nvidia.com>

Note that this patch depends on the patch I just posted titled
"regulator: tps6586x: add support for SYS rail". I also believe Laxman
will be posting another patch based on these 2 soon (it will move the
regulator DT parsing out of the MFD driver into the regulator driver),
so I guess it makes sense to take them all through the same TPS6586x
topic branch in the regulator tree.

That all said, I only care about merging the first patch, "regulator:
tps6586x: add support for SYS rail", into the Tegra tree, so please
don't wait for the 3rd patch before making any tag for me to pull.

Thanks.
