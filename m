Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1EHMz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:55:57 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56217 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1EHMzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:55:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Afk819qwfHp2ePySeM3e30+UW+dXpQ4fj0cCFbRtqFfnCTex7pPZDIHxHdko2Wl7Mx
         JL6kWxbd2v6tNZA3LPBqriJsJSb5JRmpijDi4Dww+8nvB2NIcNI3mSZXnUMvoSow4WLU
         V/jvKFoDJnvcokYGn2ufWLwj4UNtsvnirFh4E=
MIME-Version: 1.0
In-Reply-To: <4DC6910F.2020008@hauke-m.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<4DC6910F.2020008@hauke-m.de>
Date: Sun, 8 May 2011 14:55:54 +0200
Message-ID: <BANLkTi=wtxH6suf8D=nzYKrBjWV9-yAQLw@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/8 Hauke Mehrtens <hauke@hauke-m.de>:
> On 05/05/2011 11:59 PM, Rafał Miłecki wrote:
> .....
>> --- /dev/null
>> +++ b/drivers/bcma/bcma_private.h
> .....
>> +
>> +#define BCMA_ADDR_BASE               0x18000000
>> +#define BCMA_WRAP_BASE               0x18100000
>> +
> ......
>> --- /dev/null
>> +++ b/drivers/bcma/scan.h
>> @@ -0,0 +1,56 @@
>> +#ifndef BCMA_SCAN_H_
>> +#define BCMA_SCAN_H_
>> +
>> +#define BCMA_ADDR_BASE               0x18000000
>> +#define BCMA_WRAP_BASE               0x18100000
>> +
> .....
>
> While graping through the code I found this. BCMA_ADDR_BASE and
> BCMA_WRAP_BASE are defined twice.

Will fix, thx.


> Why are some constants defined in purpose specific headers in
> drivers/bcma/*.h like drivers/bcma/scan.h and some in
> drivers/bcma/bcma_private.h and other in include/linux/bcma/bcma_regs.h ?

What is unclear to you in this split? It says everything. scan.h for
scanning, regs for registers, private for internal functions.

-- 
Rafał
