Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2HUNCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:02:47 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58047 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab2HUNCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <50336FA5.7020906@redhat.com>
References: <1345541833.17239.0.camel@phoenix>
	<50336FA5.7020906@redhat.com>
Date: Tue, 21 Aug 2012 15:02:45 +0200
Message-ID: <CACRpkdYy-PeyOJy32nEuByQ5K88mJfdO4PLDwF8dxj4m8+7Otw@mail.gmail.com>
Subject: Re: [PATCH] gpio: bt8xx: Fix build error due to missing include file
From: Linus Walleij <linus.walleij@linaro.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Michael Buesch <m@bues.ch>, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 1:23 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Axel,
>
> Em 21-08-2012 06:37, Axel Lin escreveu:
>> This patch fixes below build error:
>>
>>   CC [M]  drivers/gpio/gpio-bt8xx.o
>> drivers/gpio/gpio-bt8xx.c:53:40: fatal error: ../media/video/bt8xx/bt848.h: No such file or directory
>> compilation terminated.
>> make[2]: *** [drivers/gpio/gpio-bt8xx.o] Error 1
>> make[1]: *** [drivers/gpio] Error 2
>> make: *** [drivers] Error 2
>>
>> drivers/media/video/bt8xx/bt848.h is moved to drivers/media/pci/bt8xx/bt848.h
>> by commit 68de959f773a1d49096835c411390bceff5d1549
>> "[media] bt8xx: move analog TV part to be together with DTV one".
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> Thanks for the patch!
>
> I'll apply this one on my tree, as it is due to the drivers/media tree
> reorg. So, it is better to keep it close to the patches there.

OK you take care of it!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
