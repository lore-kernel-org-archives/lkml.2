Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2BSHpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:45:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4430 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2BSHpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:45:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 18 Feb 2012 23:44:59 -0800
Message-ID: <4F40A7EE.8060805@nvidia.com>
Date: Sun, 19 Feb 2012 13:12:38 +0530
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
Subject: Re: [PATCH V2] mfd: tps65910: Add wakeup support
References: <1327304775-12202-1-git-send-email-ldewangan@nvidia.com> <20120126105452.GB8041@opensource.wolfsonmicro.com>
In-Reply-To: <20120126105452.GB8041@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,
Can you please review this patch? This is require in order of enabling 
the wakeup from sub devices of this pmic device like  rtc/onkey.

Thanks,
Laxman

On Thursday 26 January 2012 04:24 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jan 23, 2012 at 01:16:15PM +0530, Laxman Dewangan wrote:
>> Implementing irq_set_wake() so that device should able
>> to wakeup the system through different interrupt provided
>> by this device like gpios, onkey, rtc etc.
> Reviewed-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>
> It will have the side effect of making all interrupts on the PMIC wake
> if any of them does but I suspect this is actually going to be fine in
> practice.
>
> * Unknown Key
> * 0x6E30FDDD

