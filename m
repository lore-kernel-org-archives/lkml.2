Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2KFIfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:35:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9965 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2KFIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:35:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 06 Nov 2012 00:35:07 -0800
Message-ID: <5098CB3C.1080301@nvidia.com>
Date: Tue, 6 Nov 2012 14:03:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: tps80031: add regulator driver for tps80031
References: <1352108658-14289-1-git-send-email-ldewangan@nvidia.com> <1352108658-14289-3-git-send-email-ldewangan@nvidia.com> <20121105104246.GC1385@opensource.wolfsonmicro.com> <5097AA42.8090407@nvidia.com> <20121106081647.GC3283@opensource.wolfsonmicro.com>
In-Reply-To: <20121106081647.GC3283@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 November 2012 01:46 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Nov 05, 2012 at 05:30:02PM +0530, Laxman Dewangan wrote:
>> On Monday 05 November 2012 04:12 PM, Mark Brown wrote:
>
>> I have single dcdc ops for all DCDC VIO, SMPS1 to 3.
>> There is different configuration bit for selecting any DCDC to
>> normal, extended or offset. As this ops are share, I can not change
>> the callbacks.
> You can change your code so that it changes the ops it registers
> depending on the configuration.

I rewrote this using the desc.min_uV and desc.step_uV and table in 
another patch which I posted.  This parameter get configured based on 
these bits value.
I have updated the patch v2.


