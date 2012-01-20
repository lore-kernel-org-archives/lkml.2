Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2ATNIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:08:06 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10969 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2ATNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:08:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 20 Jan 2012 05:07:58 -0800
Message-ID: <4F19671E.7030003@nvidia.com>
Date: Fri, 20 Jan 2012 18:37:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] mfd: tps65910: Add wakeup support
References: <1327057770-6688-1-git-send-email-ldewangan@nvidia.com> <20120120125152.GE18297@opensource.wolfsonmicro.com> <4F196568.1080503@nvidia.com> <20120120130201.GF18297@opensource.wolfsonmicro.com>
In-Reply-To: <20120120130201.GF18297@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 January 2012 06:32 PM, Mark Brown wrote:
> On Fri, Jan 20, 2012 at 06:30:24PM +0530, Laxman Dewangan wrote:
>
>> I did not get how the wakeup enabled in power management infrastructure?
>> My understanding is that we need to call the two apis
>> device_wakeup_init() and
>> enable_irq_wake() for enabling the wakeup functionality.
>> Is there any other API which does the same and I need to call from
>> the core driver?
> No, that's it - when you call those userspace will get control via sysfs
> for turning on and off the wakeup support.
So should I call them in driver by default without taking parameter from 
platform data?



