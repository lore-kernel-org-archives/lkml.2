Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2BQKdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:33:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2452 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2BQKdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:33:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 17 Feb 2012 02:33:10 -0800
Message-ID: <4F3E2C62.2040708@nvidia.com>
Date: Fri, 17 Feb 2012 16:00:58 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "dunlap@xenotime.net" <dunlap@xenotime.net>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V1 2/3] Documentation: gpio: Add details of open-drain
 configuration
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>	<1329114588-15430-3-git-send-email-ldewangan@nvidia.com>	<20120213211809.GI11077@ponder.secretlab.ca>	<CACRpkdZzcN5oi0ejeTQn3BNJ_w6XHsBQ_RoQMvpf8Lt2bOARAg@mail.gmail.com>	<4F3CBE3F.1090604@nvidia.com> <CACRpkdaFyxU-gq5ETnNc4LonTo98PbUs09CmvsPUqzyt0Mg2Cg@mail.gmail.com>
In-Reply-To: <CACRpkdaFyxU-gq5ETnNc4LonTo98PbUs09CmvsPUqzyt0Mg2Cg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 February 2012 01:30 AM, Linus Walleij wrote:
> On Thu, Feb 16, 2012 at 9:28 AM, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>
>> Yes, I can add the open source also but like to be in incremental change.
>> Not together with open drain.
>> We can go with:
>> - open drain core driver support.
>> - open drain sysfs interface support
>> - open source core driver support
>> - open source sysfs interface.
>>
>> I have already changes for the first 2 which we can review/apply,
>> Meanwhile I will work on open source support.
>>
>> Does it look good?
> Well as a patch concept it is OK but I have real bad feelings about
> patch  [2/4] and [4/4] adding sysfs.
>
> What the GPIO subsystem really needs is to get rid of sysfs
> interfaces, have them deprecated and replaced with a
> per-gpiochip /dev/gpioN with ioctl()s or similar instead. The sysfs
> interface is just ... it won't scale.
>
Wow, then I will not add 2/4 and 4/4.

> Yours,
> Linus Walleij

