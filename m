Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab2GEPRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:17:31 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52208 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab2GEPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:17:28 -0400
Message-ID: <4FF5B004.4080100@linaro.org>
Date: Thu, 05 Jul 2012 16:17:24 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH] of: address: Don't fail a lookup just because a node
 has no reg property
References: <1341498754-30445-1-git-send-email-lee.jones@linaro.org> <4FF5AB4D.6090500@gmail.com>
In-Reply-To: <4FF5AB4D.6090500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 15:57, Rob Herring wrote:
> On 07/05/2012 09:32 AM, Lee Jones wrote:
>> Sometimes it doesn't make any sense for a node to have an address.
>> In this case device lookup will always be unsuccessful because we
>> currently assume every node will have a reg property. This patch
>> changes the semantics so that the resource address and the lookup
>> address will only be compared if one exists.
>>
>> Things like AUXDATA() rely on of_dev_lookup to return the lookup
>> entry of a particular device in order to do things like apply
>> platform_data to a device. However, this is currently broken for
>> nodes which do not have a reg property, meaning that platform_data
>> can not be passed in those cases.
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
>
> Do you have something dependent on this or want me to apply?

I have things that require this patch yes. Please apply.

Thanks Rob.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


