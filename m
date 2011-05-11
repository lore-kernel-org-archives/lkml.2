Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1EKP77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:59:59 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:49297 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756540Ab1EKP6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:48 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Wed, 11 May 2011 10:34:47 +0200
Subject: RE: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcwPThiauEaK21PqQ+KwSQ2H1GE5jwAZYqSQ
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A1A289@EXDCVYMBSTM005.EQ1STM.local>
References: <1305040232-750-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110510200801.GA8125@kroah.com>
In-Reply-To: <20110510200801.GA8125@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4BG0PlU003357

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: den 10 maj 2011 22:08
> 
> {sigh}
> 
> This breaks the build again, the error messages are below :(
> 
> I'm about to give up here, so the next time you send this patch in, I
> want some kind of proof that the code will at least build properly.
> 
> How you provide this is up to you.
> 
> Oh, and if the next one breaks stuff again, you will owe me a lot of
> beer, although I think you owe me already...
> 
> thanks,
> 
> greg k-h
> 
>   CC [M]  drivers/staging/cg2900/mfd/cg2900_chip.o
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: unknown field
> â€˜platform_dataâ€™ specified in initializer
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: warning:
> initialization makes integer from pointer without a cast
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: initializer
> element is not computable at load time
> drivers/staging/cg2900/mfd/cg2900_chip.c:2940:3: error: (near
> initialization for â€˜cg2900_devs[0].idâ€™)

Hi Greg,

What linux-next tag did you base the patch on?
I used next-20110510 and in that tag the file include/Linux/mfd/core.h
The struct mfd_cell has a parameter called platform_data, while in your
build it seems it doesn't.
This was changed very recently in the core.h file (on April 6).
So for core.h the last commit ID I have in the tag I built upon is
558aa9c0d620b91a896d5e39ce8a570bed65589b.

Thanks,
P-G

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
