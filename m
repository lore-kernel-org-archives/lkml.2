Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2FTLZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:25:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44270 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2FTLZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:25:20 -0400
Message-ID: <4FE1B31C.6030100@linaro.org>
Date: Wed, 20 Jun 2012 12:25:16 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
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
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-4-git-send-email-ldewangan@nvidia.com> <4FE0A546.1010707@linaro.org> <4FE0B79D.4090201@wwwdotorg.org> <4FE1772A.2010806@linaro.org> <4FE17E24.8050702@nvidia.com> <4FE18371.2020602@linaro.org> <4FE1877C.4090103@nvidia.com> <4FE19036.1060008@linaro.org> <20120620100631.GE3978@opensource.wolfsonmicro.com>
In-Reply-To: <20120620100631.GE3978@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/12 11:06, Mark Brown wrote:
> On Wed, Jun 20, 2012 at 09:56:22AM +0100, Lee Jones wrote:
>
>>> Are you OK to have the first patch with adding property
>
> ...
>
>> Yes I'm fine with it.
>
> So is that an ack?

Sure why not. Although, Linus Walleij has the final say.

Acked-by: Lee Jones <lee.jones@linaro.org>

>> It's only the unnecessary reg and *-size properties I'm opposed to.
>
> My understanding is that they're required by DT policies in the same way
> that some of the other verbiage is.

Well I haven't put them in the DB8500 Device Tree if they're not useful 
and nothing untoward has occurred.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
