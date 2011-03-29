Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1C2Iz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:55:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44013 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1C2Iz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RfHKJy9UaIgPMq5Yj6D8UvryZXlAL+jEK+1LNVFyzoIn72OFV45NqMjtv7fQSSjuXw
         4EOjYpZUbLoJVWHv9bNzLHQYSF51UffzEnhHyKrYKYF26w/zQXMPhYe/QJQ4EKFmSIdW
         yjlCNidaawvwBPJbEw5oECn3CadxamsoEYpKs=
MIME-Version: 1.0
In-Reply-To: <201103291150.32097.anarsoul@gmail.com>
References: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com>
	<1301380363-3282-5-git-send-email-marek.belisko@open-nandra.com>
	<201103291150.32097.anarsoul@gmail.com>
Date: Tue, 29 Mar 2011 10:55:54 +0200
Message-ID: <AANLkTi=RW0o=+hXcO0Y04nq10QEd=hWY0Nzc0enJ=Tr7@mail.gmail.com>
Subject: Re: [PATCH 4/4] s3c2440: mini2440: Enable the backlight LED earlier
 at boot time.
From: Belisko Marek <marek.belisko@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, buserror@gmail.com, esta1ien@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:50 AM, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> On Tuesday 29 March 2011 09:32:43 Marek Belisko wrote:
>> Code overtaken from:
>> http://repo.or.cz/w/linux-2.6/mini2440.git
>>
>> Use flag that allows s3c24xx LED to start in the "on" state.
>> This is necesary to enable LCD backlight during early boot stage.
>
> Why are you still using leds-s3c24xx driver? mini2440 should work OK with
> leds-gpio. Anyway, looks like patch should be splitted into 2 patches: first
> adds flag to leds-s3c24xx driver, second enables this flag for mini2440.
Right with leds-gpio I can use .default_state  = LEDS_GPIO_DEFSTATE_ON,
which is same like implemented in this patch. Will change and resend.
Thanks for hint.
>
> Regards
> Vasily
>
>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>> Signed-off-by: Michel Pollet <buserror@gmail.com>
>> ---
>>  arch/arm/mach-s3c2410/include/mach/leds-gpio.h |    1 +
>>  arch/arm/mach-s3c2440/mach-mini2440.c          |    1 +
>>  drivers/leds/leds-s3c24xx.c                    |    6 +++++-
>>  3 files changed, 7 insertions(+), 1 deletions(-)
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
