Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2EGOkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:40:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15659 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab2EGOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:40:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 07 May 2012 07:40:44 -0700
Message-ID: <4FA7DE29.3020004@nvidia.com>
Date: Mon, 7 May 2012 20:07:29 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] regulator: tps62360: enable register cache
References: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com> <1336394306-2211-2-git-send-email-ldewangan@nvidia.com> <20120507142453.GG17002@opensource.wolfsonmicro.com>
In-Reply-To: <20120507142453.GG17002@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012 07:54 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, May 07, 2012 at 06:08:25PM +0530, Laxman Dewangan wrote:
>> Enable cache of device register using regmap cache RBTREE.
> Applied both, thanks.
>

Thanks for taking care.

>> Just resending as part of this series.
> You did fix the thing with the defaults.

Oops, I really forgot this change after doing test as more concentration 
on removing dependency.

