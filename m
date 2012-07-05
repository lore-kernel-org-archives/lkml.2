Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab2GEPus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:50:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42655 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab2GEPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:50:45 -0400
Message-ID: <4FF5B7D2.8000909@linaro.org>
Date: Thu, 05 Jul 2012 16:50:42 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH] of: address: Don't fail a lookup just because a node
 has no reg property
References: <1341498754-30445-1-git-send-email-lee.jones@linaro.org> <4FF5AB4D.6090500@gmail.com> <4FF5B004.4080100@linaro.org> <201207051538.37687.arnd@arndb.de>
In-Reply-To: <201207051538.37687.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 16:38, Arnd Bergmann wrote:
> On Thursday 05 July 2012, Lee Jones wrote:
>>>
>>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>>>
>>> Do you have something dependent on this or want me to apply?
>>
>> I have things that require this patch yes. Please apply.
>
> I guess Rob's question was whether you want to keep this together
> with the patch that depends on it rather than him applying just
> the one patch.

No, it's not important.

I'll send you the other patch as part of my DT pull-request.

I'm just waiting on Linus' Ack on a few patches and it'll be ready.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


