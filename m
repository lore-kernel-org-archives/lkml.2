Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1IWJxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:53:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46084 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1IWJxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:53:38 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CAKT61h95WFp=zdyW=TyVcnTpDOyR_avrkcfSH4JetXYa3efCyA@mail.gmail.com>
References: <1316697473.6704.4.camel@phoenix> <CAKT61h95WFp=zdyW=TyVcnTpDOyR_avrkcfSH4JetXYa3efCyA@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 23 Sep 2011 17:53:17 +0800
Message-ID: <CAF+7xWmuBaq=h9rgrukyj0hu_z=ES0Q5vs7EMuRdkW8xW6pjuw@mail.gmail.com>
Subject: Re: [linux-next next-20110922] build failure due to missing arch/arm/mach-nuc93x/Kconfig
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/23 Wan ZongShun <mcuos.com@gmail.com>:
> 2011/9/22 Axel Lin <axel.lin@gmail.com>:
>> I got below error with today's linux-next tree (next-20110922).
>>
>> $ make menuconfig
>> scripts/kconfig/mconf Kconfig
>> arch/arm/Kconfig:972: can't open file "arch/arm/mach-nuc93x/Kconfig"
>> make[1]: *** [menuconfig] Error 1
>> make: *** [menuconfig] Error 2
>>
>
> I I remembered that mach-nuc93x has been removed from Linux mainline, right?
>
> So maybe it reasons from the git merge issue.

It's fixed in today's linux-next tree  ( next-20110923 ).
Thanks,
Axel

>
>> Regards,
>> Axel
>>
>>
>
>
>
> --
> Wan ZongShun.
> www.mcuos.com
>
