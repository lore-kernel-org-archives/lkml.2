Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1F1JvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:51:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab1F1Jtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pt7ro3NDAk0ueNhxJ32WbkeUMUrRm4zybdRgPbfssRQtgCogW2zRAjFD109yH9lQeg
         ZOPj7L8VdDv9gQNl76IIHN7Zs/rfapB8CeaTrZuScBnCIpmMMPDpX3pTWsiE4KzJ2YK3
         pRF4AbstVVYLDB6dtHxME2/urIfUccugPY0Wc=
MIME-Version: 1.0
In-Reply-To: <BANLkTin_axWbYNKox+R59VmEq7tggaKvHQ@mail.gmail.com>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	<BANLkTin_axWbYNKox+R59VmEq7tggaKvHQ@mail.gmail.com>
Date: Tue, 28 Jun 2011 11:49:31 +0200
X-Google-Sender-Auth: 5OBSyhIqHSjgZJg96_qp_zO9BwU
Message-ID: <BANLkTin4w2QWGNxqbyZyzO+wCmkBH6eUVg@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/28 Rafał Miłecki <zajec5@gmail.com>:
> Hopefully last thing ;)
>
> 2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
>> m68k allmodconfig:
>>
>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> --
>
>
> If this is not manual mistake, you may want to fix your script or
> whatever you use. You typed "--" instead of "---", which resulted in
> the following commit message:

It's a manual mistake :-)

> m68k allmodconfig:
>
>  drivers/bcma/main.c: In function â€˜bcma_release_core_devâ€™:
>  drivers/bcma/main.c:68: error: implicit declaration of function â€˜kfreeâ€™
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>  --
>  http://kisskb.ellerman.id.au/kisskb/buildresult/4243344/
>
>  drivers/bcma/main.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
