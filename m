Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1DEIaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:30:15 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:59435 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab1DEIaM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:30:12 -0400
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
Date: Tue, 5 Apr 2011 10:28:22 +0200
Subject: RE: [PATCH v3] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH v3] staging: Add ST-Ericsson CG2900 driver
Thread-Index: AcvzZHxP+x3PLw+lTZ6TdRSm28Yq8wABr0XQ
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA3393929516@EXDCVYMBSTM005.EQ1STM.local>
References: <1301399358-10783-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110405060844.GA15065@kroah.com>
In-Reply-To: <20110405060844.GA15065@kroah.com>
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
> Sent: den 5 april 2011 08:09
> > +config CG2900_UART
> > +	tristate "Support CG2900 UART transport"
> > +	depends on CG2900
> > +	select BT
> > +	select BT_HCIUART
> 
> No, depend on this, don't have a staging driver select any other config
> options, sorry.
> 
> Care to fix this up, and your drivers/staging/Kconfig fuzz in the patch
> and resend it?
> 
> thanks,
> 
> greg k-h

This is code left from the non-staging state. I will update and resend.

Thanks,
P-G
