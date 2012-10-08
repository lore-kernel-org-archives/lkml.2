Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab2JHGdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:33:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16170 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2JHGde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:33:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 07 Oct 2012 23:22:49 -0700
Message-ID: <50726BE0.3020904@nvidia.com>
Date: Mon, 8 Oct 2012 11:30:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] regulator: tps65090: rename driver name and regulator
 name
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com> <1349536671-31714-3-git-send-email-ldewangan@nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDF8AF392@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF8AF392@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2012 11:23 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Laxman Dewangan
>> Sent: Saturday, October 06, 2012 8:48 PM
>>
>>   static struct platform_driver tps65090_regulator_driver = {
>>   	.driver	= {
>> -		.name	= "tps65090-regulator",
>> +		.name	= "tps65090-pmic",
> As the driver itself is regulator driver, why should we rename it to pmic?
>

I observed that other drivers are using the similar names 
<chip_name>-pmic and so with inline with others.
