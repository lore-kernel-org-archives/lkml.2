Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2HIMmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:42:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13535 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab2HIMmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:42:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Aug 2012 05:42:24 -0700
Message-ID: <5023AC97.60409@nvidia.com>
Date: Thu, 9 Aug 2012 17:57:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] regulator: add MAX8907 driver
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org> <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org> <5023AAE5.90603@nvidia.com> <20120809123838.GP24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120809123838.GP24328@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2012 06:08 PM, Mark Brown wrote:
> On Thu, Aug 09, 2012 at 05:49:49PM +0530, Laxman Dewangan wrote:
>
>> There may be possibility that some of regulator node is not
>> populated and that case, the idata will be NULL and hence regulator
>> registration can be bypass for that regulator.
> The driver should just register all the regulators the chip has, it's
> useful for diagnostic purposes if nothing else.

Then probably we need to update our dts file becasue we left some of 
regualtor entry as it is not used on design.

