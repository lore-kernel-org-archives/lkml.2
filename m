Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2BAGho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:37:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7294 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2BAGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:37:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 31 Jan 2012 22:37:35 -0800
Message-ID: <4F28DD6D.9030606@nvidia.com>
Date: Wed, 1 Feb 2012 12:06:29 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] gpio: tps65910: Add sleep control support
References: <1327999512-4935-1-git-send-email-ldewangan@nvidia.com> <CACRpkdZ-1VBkZN71eFqaxVi5dakP4Dt3yXLa9TTdrKE=dGq__w@mail.gmail.com>
In-Reply-To: <CACRpkdZ-1VBkZN71eFqaxVi5dakP4Dt3yXLa9TTdrKE=dGq__w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 February 2012 03:01 AM, Linus Walleij wrote:
> On Tue, Jan 31, 2012 at 9:45 AM, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>
>> The device tps65910/tps65911 supports the sleep
>> functionality in some of gpios. If gpio is configured
>> in output mode and sleep is enabled then during device
>> sleep state, the output of gpio becomes LOW regardless
>> of non-sleep output value.
>> Such gpio can be used to control regulator switch such
>> that output of regulator is off in device sleep state.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Strictly speaking this is pin control business, but since it is already
> doing other stuff like this from platform data why not...
>
> Comments:
>
Thanks for review. I have taken care of all your comments and will send 
another version with  these changes.

