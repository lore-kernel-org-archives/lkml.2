Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DTLn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:43:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1DTLn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:43:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cwQi94Mc07jdKrjrMomMUE7WVMQ6g0CkRt77x2RKh48JcehFDG3XcxCXBt9g3b54le
         /4vbNPmqxDD7ECfdLxd42isLHfxROgb7NoPCKIvPm9Iyxb1UVmOsLNQQIgSqFh7s2Psn
         9hx0CF5ojM0/GhyPeE4hbJgtdOmCEzUUq+qCg=
Message-ID: <4DAEC6DB.8000600@gmail.com>
Date: Wed, 20 Apr 2011 15:43:23 +0400
From: Igor Plyatov <plyatov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-at91: gsia18s board improvements and bug fixes
References: <1303291399-4075-1-git-send-email-plyatov@gmail.com> <20110420105120.GI4204@game.jcrosoft.org>
In-Reply-To: <20110420105120.GI4204@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean-Christophe!
> On 13:23 Wed 20 Apr     , Igor Plyatov wrote:
>> * AT91_PIN_Pxxx port names replaced by human readable GPO_xxxx, GPI_xxxx,
> I do not see the improvement

This does not mean that here is no it for all!
This is very noticeable improvement for me regarding to schematic and 
source code maintenance.

>>    GPIO_xxxx names. This simplify source code and schematic maintenance.
>> * Active logic levels and default states corrected for GPOs.
>> * Replace small functions which use platform_register_device() by its direct
>>    calls.
> ditto here

Source code is and more clean and simple now.

>> * Remove GPIO_CARD_UNMOUNT_1 gpio_keys_button, because it not used.
>> * debounce_interval added for critical buttons.
>> * Remove unneeded GPI setup code for buttons, because this done by corresponding
>>    driver.
>> * pcf8574x_0x20_setup() and pcf8574x_0x20_teardown functions small refactoring.
> Best Regards,
> J.

