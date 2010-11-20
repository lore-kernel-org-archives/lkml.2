Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab0KTFwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 00:52:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50666 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0KTFwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 00:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uow+4FqbqqwKmQ62VRaOHEDuOwENKqxbRstHMcSwIAi6xu8M+4YPHtmcKXZtA5oggk
         Y8INv5TpqgEAPsDMo7V09Mhq84fURFr+WMDVAz5EIht8UPfgf7hLUS/nN25Ebkz9Oufk
         ExlFYHIASlQDYQ4sgUGcT36P3vPocPf2V+pro=
MIME-Version: 1.0
In-Reply-To: <AANLkTik0jXvoNTfNzAGAnzDQbE5oyEVmQ0hVyYt84jGQ@mail.gmail.com>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
	<AANLkTik0jXvoNTfNzAGAnzDQbE5oyEVmQ0hVyYt84jGQ@mail.gmail.com>
Date: Sat, 20 Nov 2010 06:52:09 +0100
Message-ID: <AANLkTinUToUN8sfRBtTQm=8TeTGxDBwPnJC8j8zrJ_8c@mail.gmail.com>
Subject: Re: linux-next: Tree for November 19
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 20 listopada 2010 06:50 u¿ytkownik Zimny Lech
<napohybelskurwysynom2010@gmail.com> napisa³:
> Hi,
>
> 2010/11/19 Stephen Rothwell <sfr@canb.auug.org.au>:
>> Hi all,
>>
>> Changes since 20101118:
>
> I do not recall that I saw it before
>  CC [M]  drivers/block/cciss.o
> /home/test/linux-2.6/drivers/block/cciss.c: In function 'cciss_cleanup':
> /home/test/linux-2.6/drivers/block/cciss.c:4929:6: error: 'proc_cciss'
> undeclared (first use in this function)
> /home/test/linux-2.6/drivers/block/cciss.c:4929:6: note: each
> undeclared identifier is reported only once for each function it
> appears in
> make[3]: *** [drivers/block/cciss.o] Error 1
> make[2]: *** [drivers/block] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2
>

BTW. mainline too I guess



-- 
Slawa!
N.P.S.

Chwa³a tobie, Szatanie, cze¶æ na wysoko¶ciach
Nieba, gdzie królowa³e¶, chwa³a w g³êboko¶ciach
Piek³a, gdzie zwyciê¿ony, trwasz w dumnym milczeniu!
Uczyñ, niechaj ma dusza spocznie z Tob± w cieniu
Drzewa Wiedzy, gdy swoje konary rozwinie,
Jak sklepienie ko¶cio³a, który nie przeminie!
