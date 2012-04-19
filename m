Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2DSJNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:13:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8630 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2DSJNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:13:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 19 Apr 2012 02:13:11 -0700
Message-ID: <4F8FD709.60308@nvidia.com>
Date: Thu, 19 Apr 2012 14:42:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>, Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] ARM: dt: tegra_ventana: als and proximity sensor
 isl29018 support
References: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com> <1334645155-13799-4-git-send-email-ldewangan@nvidia.com> <4F8DF01D.9040900@wwwdotorg.org>
In-Reply-To: <4F8DF01D.9040900@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012 04:05 AM, Stephen Warren wrote:
> On 04/17/2012 12:45 AM, Laxman Dewangan wrote:
>> Add the device info for ALS and proximity sensor isl29018.
>
> a) Perhaps the vendor prefix should be "isil" not "isl". Olof, can you
> please comment here?
>

Any comments on this? I think "isil" is good as it is the symbol in 
nasdaq also: Intersil Corporation (ISIL).
If no objection than I can send my next version of patch ;)

Adding LinusW, Mark and Grant if they have any comment here.

