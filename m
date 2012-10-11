Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2JKPGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:06:22 -0400
Received: from nbd.name ([46.4.11.11]:46485 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851Ab2JKPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:06:21 -0400
Message-ID: <5076DFB7.40709@openwrt.org>
Date: Thu, 11 Oct 2012 17:03:19 +0200
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Wei Yongjun <weiyj.lk@gmail.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] pinctrl: remove duplicated include from pinctrl-xway.c
References: <CAPgLHd_XnZU_E3zso2F1y1GFYHewrGUSSSf8yG9LRjVkbpGL=w@mail.gmail.com> <CACRpkdYxSRAVjsKyYwMDvZ7qGW1zBBQn4SwfEV-GGGPc=ukayw@mail.gmail.com>
In-Reply-To: <CACRpkdYxSRAVjsKyYwMDvZ7qGW1zBBQn4SwfEV-GGGPc=ukayw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/12 16:00, Linus Walleij wrote:
> On Wed, Oct 10, 2012 at 2:59 PM, Wei Yongjun<weiyj.lk@gmail.com>  wrote:
>
>> From: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
>>
>> Remove duplicated include.
>>
>> dpatch engine is used to auto generate this patch.
>> (https://github.com/weiyj/dpatch)
>>
>> Signed-off-by: Wei Yongjun<yongjun_wei@trendmicro.com.cn>
> Applied to my fixes branch, unless John C has objections, I'll
> keep it there.
>

no objections from me ... thanks for the fix !

     John
