Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab2GML4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 07:56:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53318 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2GML4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 07:56:48 -0400
Message-ID: <50000CFC.5040402@linaro.org>
Date: Fri, 13 Jul 2012 13:56:44 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rajanikanth HV <rajanikanth.hv@stericsson.com>
CC: "linaro-dev-request@lists.linaro.org" 
	<linaro-dev-request@lists.linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH] mfd: Implement devicetree support for AB8500 Btemp
References: <mailman.377.1341937217.1590.linaro-dev@lists.linaro.org> <50000635.70102@stericsson.com>
In-Reply-To: <50000635.70102@stericsson.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> @@ -964,11 +966,13 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>>>    {
>>>        int irq, i, ret = 0;
>>>        u8 val;
>>> -     struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;
>>
>> I already told you about this.
> your previous comment was: "No, it's meant to work with _both_ platform
> and Device Tree registation."

Right.

> Why is this required when platform specific information/file is removed?

It's not being removed, it's just not allowed to be upstreamed. Once we 
enforce Device Tree only booting, we'll go round and remove that 
capability from the drivers. Until then, you must ensure all Device Tree 
enablement works in parallel with platform registration.

Concentrate on enabling the drivers for DT for now and we'll extract 
platform data support later.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


