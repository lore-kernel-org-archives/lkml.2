Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab1CWPys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:54:48 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:39938 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933157Ab1CWPyq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:54:46 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vitaly Wool <vitalywool@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Lee Jones <lee.jones@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Wed, 23 Mar 2011 16:26:42 +0100
Subject: RE: [PATCH 1/2] staging: Add ST-Ericsson CG2900 driver
Thread-Topic: [PATCH 1/2] staging: Add ST-Ericsson CG2900 driver
Thread-Index: Acvpbcuz1ANEow6wR+uIsqObJIoCjwAAJfCw
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA334C4DE8B7@EXDCVYMBSTM005.EQ1STM.local>
References: <1300888771-26437-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <20110323082002.bd60cea1.rdunlap@xenotime.net>
In-Reply-To: <20110323082002.bd60cea1.rdunlap@xenotime.net>
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

Hi Randy,

> > +
> > +config CG2900_AUDIO
> > +	tristate "Support CG2900 audio interface"
> > +	depends on CG2900
> > +	help
> > +	  Support for ST-Ericsson CG2900 Connectivity audio
> interface. Gives a
> > +	  module the ability to setup audio paths within the CG2900
> controller.
> > +
> 
> Just to be clear:  the cg2900_audio driver does not use any current
> kernel
> sound/audio interfaces, right?
> 

No, it provides an interface to the audio features within the chip.
So it is rather used by other sound/audio drivers, but it never
use any sound/audio interfaces itself.

Thanks,
/P-G
