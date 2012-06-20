Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2FTL2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:28:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8218 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2FTL2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:28:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 04:24:58 -0700
Message-ID: <4FE1B3A6.6090600@nvidia.com>
Date: Wed, 20 Jun 2012 16:57:34 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] ARM: dts: db8500: add node property "regulator-compatible"
 regulator node
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-4-git-send-email-ldewangan@nvidia.com> <4FE0A546.1010707@linaro.org> <4FE0B79D.4090201@wwwdotorg.org> <4FE1772A.2010806@linaro.org> <4FE17E24.8050702@nvidia.com> <4FE18371.2020602@linaro.org> <4FE1877C.4090103@nvidia.com> <4FE19036.1060008@linaro.org> <20120620100631.GE3978@opensource.wolfsonmicro.com> <4FE1B31C.6030100@linaro.org>
In-Reply-To: <4FE1B31C.6030100@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2012 04:55 PM, Lee Jones wrote:
> On 20/06/12 11:06, Mark Brown wrote:
>> On Wed, Jun 20, 2012 at 09:56:22AM +0100, Lee Jones wrote:
>>
>>>> Are you OK to have the first patch with adding property
>> ...
>>
>>> Yes I'm fine with it.
>> So is that an ack?
> Sure why not. Although, Linus Walleij has the final say.
>
> Acked-by: Lee Jones<lee.jones@linaro.org>
>

I am going to send the new patch having "regulator-compatible" on each 
child node only for db8500.dtsi, and removing all other changes.



