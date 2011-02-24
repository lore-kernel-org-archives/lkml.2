Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab1BXVJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:09:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51147 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BXVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:09:47 -0500
Message-ID: <4D66C912.8090205@mail.berlios.de>
Date: Thu, 24 Feb 2011 22:09:38 +0100
From: Stefan Weil <weil@mail.berlios.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: Fix memory leak after kmalloc failure
References: <1298158151-22903-1-git-send-email-weil@mail.berlios.de> <20110223220533.GA23425@kroah.com>
In-Reply-To: <20110223220533.GA23425@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ICb3UXrXKTDU+v4B6Q9PXwXKuWxMZIomsG6A1YxN9Y/
 yKQwNck2kDxFhDrSMkdDaJSoB2Z1vw7AmtYB/A1L7f66AE8lKa
 YQHSK9IdvSaL4ZQoshagN0+HDzQINl8dswOuN94LrwFZd1xLVQ
 xCI7ddDsYMlJ+mjmSxlF01nwCgCZUKNmuvu/EjyY3IHqHmiU3F
 A53TNOvENUC0LlQO5V1oOsyqs01rLqyRLIiDtroQtaH+qQVVMa
 T9l6AOqW+D24a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.02.2011 23:05, schrieb Greg KH:
> On Sun, Feb 20, 2011 at 12:29:11AM +0100, Stefan Weil wrote:
>> This error was spotted by cppcheck:
>>
>> drivers/staging/brcm80211/phy/wlc_phy_lcn.c:4053: error: Memory leak: ptr
>>
>> Cc: Brett Rudley <brudley@broadcom.com>
>> Cc: Henry Ptasinski <henryp@broadcom.com>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: devel@driverdev.osuosl.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
>> ---
>> drivers/staging/brcm80211/phy/wlc_phy_lcn.c | 1 +
>
> What tree did you make this against? This file isn't in the linux-next
> tree anymore.
>
> thanks,
>
> greg k-h

The patch was based on 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git.

In linux-next, the file was moved to a different directory:

from drivers/staging/brcm80211/phy/wlc_phy_lcn.c
to   drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c

It still needs the same fix. I'll send a new patch based on latest 
linux-next.

Regards
Stefan W.

