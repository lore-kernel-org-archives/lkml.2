Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2JIGlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:41:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4112 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2JIGlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:41:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 08 Oct 2012 23:39:32 -0700
Message-ID: <5073BF39.5020008@nvidia.com>
Date: Tue, 9 Oct 2012 11:37:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: TPS51632: Add tps51632 regulator driver
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com> <1349536671-31714-2-git-send-email-ldewangan@nvidia.com> <20121009061436.GH8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009061436.GH8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012 11:44 AM, Mark Brown wrote:
> On Sat, Oct 06, 2012 at 08:47:46PM +0530, Laxman Dewangan wrote:
>
> Actually...
>
>> +	if (pdata->dvfs_step_20mV)
>> +		control |= TPS51632_DVFS_STEP_20;
>> +	tps->desc.uV_step = TPS51632_VOLATGE_STEP_10mV;
> Shouldn't the dvfs_step_20mV setting affect the uV_step size?
The dvfs_step_20mV will only effect for the control through DVFS (PWM).
The voltage control an voltage base register will till use the 10mV steps.


