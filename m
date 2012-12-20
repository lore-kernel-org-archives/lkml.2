Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2LTBNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:13:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21442 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2LTBNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:13:39 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-8a-50d266428b79
Message-id: <50D26652.1020205@samsung.com>
Date: Thu, 20 Dec 2012 10:13:54 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linus.walleij@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] gpio: samsung: remove exynos_gpio_cfg
References: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
 <20121219222255.49E263E0AD6@localhost>
In-reply-to: <20121219222255.49E263E0AD6@localhost>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t8zTV2ntEsBBlfm8ltc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW82dDCVtDAUfH15UGWBsbjbF2MnBwSAiYS98//YIGw
	xSQu3FsPFhcSWMYocfunC0xNa8tmoDgXUHw6o8SvXYuZIYpeMkrMmGPexcjBwSugJbHnrCFI
	mEVAVaL58Dp2EJtNQE/izrbjTCC2qICfxNm57xhBbF4BQYkfk++xgLSKCOhIPDsnCDKeWWAi
	o8SFHx/BxgsLWEn8PrWMCWJVgcSlz3fB7uQUMJaY2fgHbD6zgLXEyknbGCFseYnNa94yQ9wg
	IPFt8iGw+RICshKbDjCDzJcQmMwusWb+X3aIvyQlDq64wTKBUWwWkpNmIRk7C8nYBYzMqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzFCIkNqB+PKBotDjAIcjEo8vAWrLgQIsSaWFVfmHmKU
	4GBWEuFdeOtigBBvSmJlVWpRfnxRaU5q8SFGH6BrJzJLiSbnA6M2ryTe0NjA2NDQ0tDM1NLU
	AIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGooLFei8VIhofhSa4BH/snKuU0rlOMrwv
	ICpBd/vpC3y7m1extzkL5r2N7znlsfvvwfYOhyWffKVWNXybta0iQVBQ5lOnxzf/xhsmlm9d
	6zfc5pq8aE3+1efHrgazsSxs109QPCt6/f7d21++X7je3bQt4JZs6H2uzi9fu20rN98N+dB2
	1kJCiaU4I9FQi7moOBEAukV3SrkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV2ntEsBBj8vslpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvNnQwlbQwFHx
	9eVBlgbG42xdjJwcEgImEq0tm6FsMYkL99YD2VwcQgLTGSV+7VrMDJIQEnjJKDFjjnkXIwcH
	r4CWxJ6zhiBhFgFViebD69hBbDYBPYk7244zgdiiAn4SZ+e+YwSxeQUEJX5MvscC0ioioCPx
	7JwgyHhmgYmMEhd+fAQbLyxgJfH71DImiFUFEpc+32UBsTkFjCVmNv4Bm88sYC2xctI2Rghb
	XmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfeM6kd
	jCsbLA4xCnAwKvHwFqy6ECDEmlhWXJl7iFGCg1lJhHfhrYsBQrwpiZVVqUX58UWlOanFhxh9
	gCEwkVlKNDkfmBTySuINjU3MjCyNzIxNzI2NcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCU
	amBMMXhmxRnwR+urjKrk5MQyjXU3ao4zWm/9m8FcubMzNrp5wfffV9g/Nk+T3CO08Nn69Y0h
	7TN5Z8jKhnT7mn7LdJm7wvda3Cu9Ks0HD6eem7O41Elj8o5itkmf4kxSrCMr9adpP1jM5VDu
	fVdstcP7irn9EZ/b58Xd/HFKZVG9X2urc1On610lluKMREMt5qLiRACFpyV96QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 12/20/2012 07:22 AM, Grant Likely wrote:
> On Fri, 14 Dec 2012 19:44:01 +0900, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>> The exynos_gpio_cfg can be substituted to samsung_gpio_cfgs[8].
>>
>> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Hi Joonyoung,
>
> I need some help here. I don't understand what this patch is for or how
> it works. The commit text above doesn't give me enough information to
> evaluate the patch. What is the intent here? Why is samsung_gpio_cfgs[8]
> more correct than exynos_gpio_cfg?

First, i just wondered why samsung_gpio_cfgs[8] is used in the
exynos4_gpios_2[] even if exynos_gpio_cfg is exist and found
samsung_gpio_cfgs[8] does same thing with exynos_gpio_cfg. The
exynos_gpio_cfg is used only for Exynos SoCs so it is compiled by #if
defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5).
I think one can be removed because they are duplicated codes and it is
better to decrease use of #if defined.

Thanks.

> g.
>
>

