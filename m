Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab2KWAaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:30:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9007 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2KWA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:29:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 22 Nov 2012 16:29:56 -0800
Message-ID: <50AEC382.1090105@nvidia.com>
Date: Fri, 23 Nov 2012 05:59:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com> <Pine.LNX.4.64.1211190900110.11024@axis700.grange> <50AAE2BF.2000909@nvidia.com> <Pine.LNX.4.64.1211201027190.21420@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211201027190.21420@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012 03:12 PM, Guennadi Liakhovetski wrote:
> Hi Laxman
>
> On Tue, 20 Nov 2012, Laxman Dewangan wrote:
>
>>>
>>> Here you actually need an offset within your register address space, so,
>>> should be
>>>
>>> +       max->lru_index[0] = pdata->dvs_def_state;
>>
>> Yaah, seems some issue if vout_base is not zero. But really dont require here
>> as MAX8973_VOUT is 0 in this case.
> I think cleanly differentiating between register addresses, offsets and
> indices is important.
>


Ok, I will push the patch. Seems same fixing is also require for 
tps62360 regulator.

