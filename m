Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1AEUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:39:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61158 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1AEUjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cB3daiC+/iXJMAncGPM+ppU9XswkbEXNMZqcbXqg327W9aw7k1NHD2D+ZLlPp9f+3y
         41FiBa2m1hxyfAgP/n/qYLUbV5oeoqirE1LQ946stWbFotfhr+C3VXSYOS1JCiNf7T5E
         uET2HabZ027g+mfiaXYarQvrrfCTgxsJUDJhM=
MIME-Version: 1.0
In-Reply-To: <20110104133256.004ff54e.akpm@linux-foundation.org>
References: <88652C7DDEB86A45A61D4100C612CD731E8CFB@exchtp12.taipei.via.com.tw>
	<4D15045C.90909@gmx.de>
	<20110104133256.004ff54e.akpm@linux-foundation.org>
Date: Wed, 5 Jan 2011 21:39:29 +0100
X-Google-Sender-Auth: ZNkPY6YSTFHxwMY55wQXpM6gHX8
Message-ID: <AANLkTi=UQhs=6+DpSjdGyNyEXEB=nV_8bDQVbCqp1FeK@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update entries affecting VIA Technologies
 (resent as plaintext with hopefully all broken formatting fixed; merry Christmas)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        BruceChang@via.com.tw, linux-kernel@vger.kernel.org,
        BenjaminPan@viatech.com, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 22:32, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 24 Dec 2010 21:36:44 +0100
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>
>> From: Bruce Chang <BruceChang@via.com.tw>
>> Date: Fri, 17 Dec 2010 21:05:57 +0800
>> Subject: [PATCH] MAINTAINERS: update entries affecting VIA Technologies
>>
>> Since the original maintainer-Joseph Chan (josephchan@via.com.tw)
>> doesn't handle the Linux driver for VIA now, I would like to request to
>> update the maintainer for the SD/MMC CARD CONTROLLER DRIVER and VIA
>> UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER before we find a better one.
>> Thank you very much for help.
>>
>> Sign-off by: Bruce Chang < brucechang@via.com.tw >
>>
>> --- linux-b4-modified/MAINTAINERS       2010-12-16 09:24:48.000000000 +0800
>> +++ linux-aftr-modified/MAINTAINERS     2010-12-17 16:50:00.793647029 +0800
>> @@ -6384,13 +6384,12 @@
>>   F:  drivers/i2c/busses/i2c-viapro.c
>>
>>   VIA SD/MMC CARD CONTROLLER DRIVER
>> -M:   Joseph Chan <JosephChan@via.com.tw>
>> +M:   Bruce Chang <brucechang@via.com.tw>
>>   M:  Harald Welte <HaraldWelte@viatech.com>
>>   S:  Maintained
>>   F:  drivers/mmc/host/via-sdmmc.c
>>
>>   VIA UNICHROME(PRO)/CHROME9 FRAMEBUFFER DRIVER
>> -M:   Joseph Chan <JosephChan@via.com.tw>
>>   M:  Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>>   L:  linux-fbdev@vger.kernel.org
>>   S:  Maintained
>
> - the patch was still space-stuffed.
>
> - Use "Signed-off-by:", not "Sign-off by:"
>
> - please cc the relevant mailing list and maintainer (Geert) on patches

Paul Mundt handles fbdev-2.6.git.

> - As you (Florian) forwarded the patch, it should have included your
>  Signed-off-by: as well.  I made that change to my copy of the patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
