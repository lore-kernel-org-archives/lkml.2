Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230Ab2EXUQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:16:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2EXUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:16:04 -0400
Message-ID: <4FBE96E4.5070203@redhat.com>
Date: Thu, 24 May 2012 22:15:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: linux-next: Tree for May 24 (hwmon/sch56xx)
References: <20120524164915.fc6b1d90b75c50baab856280@canb.auug.org.au> <4FBE7915.2000704@xenotime.net>
In-Reply-To: <4FBE7915.2000704@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/24/2012 08:08 PM, Randy Dunlap wrote:
> On 05/23/12 23:49, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120523:
>
>
>
>
> when CONFIG_WATCHDOG is not enabled:
>
> drivers/built-in.o: In function `sch56xx_watchdog_register':
> (.text+0x50711c): undefined reference to `watchdog_register_device'
> drivers/built-in.o: In function `sch56xx_watchdog_unregister':
> (.text+0x507171): undefined reference to `watchdog_unregister_device'
>
> or when SCH56XX_COMMON=m:
>
> ERROR: "watchdog_unregister_device" [drivers/hwmon/sch56xx-common.ko] undefined!
> ERROR: "watchdog_register_device" [drivers/hwmon/sch56xx-common.ko] undefined!

Thanks for catching this, I'll send a patch to linux-watchdog + linux-next
fixing this.

Regards,

Hans
