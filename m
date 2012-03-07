Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066Ab2CGSKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:10:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12657 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851Ab2CGSKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:10:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 07 Mar 2012 10:10:52 -0800
Message-ID: <4F57A419.9090501@nvidia.com>
Date: Wed, 7 Mar 2012 23:38:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com> <20120307173157.GT3107@opensource.wolfsonmicro.com> <20120307173922.GB1130@pengutronix.de> <20120307174443.GV3107@opensource.wolfsonmicro.com>
In-Reply-To: <20120307174443.GV3107@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The open drain support is already available from next-20120306.
I was waiting for the change to be in tree before sending this patch.
Hope I am not missing anything here.


On Wednesday 07 March 2012 11:14 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Mar 07, 2012 at 06:39:22PM +0100, Wolfram Sang wrote:
>> On Wed, Mar 07, 2012 at 05:31:57PM +0000, Mark Brown wrote:
>>> Reviwed-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>> Typo ;)
> Not at all, it's a direct demonstration of the quick review I did!  :P
>
> * Unknown Key
> * 0x6E30FDDD

