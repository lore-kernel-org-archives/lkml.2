Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2JIKgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:36:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2734 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2JIKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:36:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 09 Oct 2012 03:34:14 -0700
Message-ID: <5073F63B.9020606@nvidia.com>
Date: Tue, 9 Oct 2012 15:32:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/4] regulator: tps65090: add external control support
 for DCDC
References: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com> <1349776142-6409-5-git-send-email-ldewangan@nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDF8AF6F1@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF8AF6F1@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012 04:03 PM, Venu Byravarasu wrote:
>> +static struct regulator_ops tps65090_ext_control_ops = {
>> +};
> What is the purpose of adding empty structure?
>
We will not able to register regulator if there is no ops.
In regulator register:
         if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
                 return ERR_PTR(-EINVAL);

