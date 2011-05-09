Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1EIMIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:08:22 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:33796 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab1EIMIU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:08:20 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Lee Jones <lee.jones@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Mon, 9 May 2011 14:07:02 +0200
Subject: RE: [PATCH v5] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH v5] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcwJu6iZijbqdeXCTUOvUpRPhCcpjAEhHp/Q
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA33959B23C3@EXDCVYMBSTM005.EQ1STM.local>
References: <1303818021-24275-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110503174937.GA18622@kroah.com>
In-Reply-To: <20110503174937.GA18622@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: den 3 maj 2011 19:50
> 
> What changed in this version?  It still doesn't apply properly to the
> linux-next tree, which shows me that I don't think anything really
> changed here.
> 

What I changed from v4 was in particular to adapt to changes to mfd.
The mfd device data name had been changed from platform_data (plus length)
to mfd_data. This was modified cg2900_chip.c and stlc2690.c.
In connection to this I also modified so we used the function mfd_get_data
to retrieve the platform data.
There had also been one parameter removed in the call to tty->ops->tiocmget
so I had to modify the call in hci_ldisc as well.

> Can you rediff it so it properly applies (i.e. why are you adding your
> driver to the middle of drivers/staging/Makefile and not at the end
> which is where it properly belongs?) and resend it?

I will do another try, but I honestly do not know why it doesn't apply.
The reason for the placement in the makefile I do not remember at the
moment, probably just a simple mistake from my part. I agree that I
should have placed it last in the file.

Thanks,
/P-G
