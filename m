Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2B0MqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:46:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18141 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2B0MqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:46:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 27 Feb 2012 04:46:02 -0800
Message-ID: <4F4B7B03.3060600@nvidia.com>
Date: Mon, 27 Feb 2012 18:15:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] Open drain/open source support from gpio library
References: <1329490582-22107-1-git-send-email-ldewangan@nvidia.com>	<1329490582-22107-2-git-send-email-ldewangan@nvidia.com> <CACRpkdZTqS=BJ3x3ib8pByY6riT3nhuQuU4+Z9w4JanicBBiwA@mail.gmail.com>
In-Reply-To: <CACRpkdZTqS=BJ3x3ib8pByY6riT3nhuQuU4+Z9w4JanicBBiwA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,
Although it is not too old patch but can you please review and if it is 
OK then apply ;)  ?

Thanks,
Laxman


On Friday 17 February 2012 11:51 PM, Linus Walleij wrote:
> On Fri, Feb 17, 2012 at 3:56 PM, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>
>> This patch is as per discussion on the patch
>> [PATCH V1] regulator: fixed: Support for open-drain gpio
>> where it was suggested to push the handling of open drain gpios
>> into the gpio libray.
> Acked-by: Linus Walleij<linus.walleij@linaro.org>
> For this patch set.
>
> Yours,
> Linus Walleij

