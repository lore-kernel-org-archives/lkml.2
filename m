Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1ELL4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:56:03 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:58648 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab1ELL4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:56:00 -0400
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
Date: Thu, 12 May 2011 13:54:46 +0200
Subject: RE: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH v6] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcwP4r5iTiZzbKiLTzOXKzxYPLLQJAAt3uGA
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A6DC72@EXDCVYMBSTM005.EQ1STM.local>
References: <1305040232-750-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110510200801.GA8125@kroah.com>
 <AFCDDB4A3EA003429EEF1E7B211FDBBA3395A1A289@EXDCVYMBSTM005.EQ1STM.local>
 <20110511134859.GB12717@kroah.com>
In-Reply-To: <20110511134859.GB12717@kroah.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4CBu8rs008016

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: den 11 maj 2011 15:49
>
> > I used next-20110510 and in that tag the file
> include/Linux/mfd/core.h
> > The struct mfd_cell has a parameter called platform_data, while in
> your
> > build it seems it doesn't.
> > This was changed very recently in the core.h file (on April 6).
> > So for core.h the last commit ID I have in the tag I built upon is
> > 558aa9c0d620b91a896d5e39ce8a570bed65589b.
> 
> So do I need that patch on the staging-next tree also?
> 
> Or is it an issue of building this on x86-64...
> 
> thanks,
> 
> greg k-h

Hi Greg,

I downloaded you staging tree and compared the logs for the core.h file.
Compared to linux-next tag next-20110510 it is missing 2 commits:
4dbee6b76fffd5740e87e286f4f4c1c15901bcae
558aa9c0d620b91a896d5e39ce8a570bed65589b
where the first one is the "oldest" one in the log and is the most
important one for my patch.
Another option would be for me to fix the patch for your tree, but
then I would probably have to fix it back in a few days when you update
your staging tree to Linux-next. How often is your tree updated?

The easiest is probably to wait a few days until you have the next-20110510
tag in your tree and then apply the patch.

Thanks,
P-G

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
