Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0LHJVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:21:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:44746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab0LHJVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:21:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,315,1288594800"; 
   d="scan'208";a="865815837"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>
CC: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 8 Dec 2010 09:20:43 +0000
Subject: RE: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Thread-Topic: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Thread-Index: AcuWuOwvV5t5vfhARoawWyLjB9gidwAABtKg
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D5E1D585@irsmsx504.ger.corp.intel.com>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	<AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
 <AANLkTin15LKaDLsd0JX=wwPOOBxkkaXTK5ojc30zoxJJ@mail.gmail.com>
In-Reply-To: <AANLkTin15LKaDLsd0JX=wwPOOBxkkaXTK5ojc30zoxJJ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oB89LThP002528

> > Hum ...
> > ACER_WMI:
> > Â select ACPI_WMI
> > Â depends on LEDS_CLASS
> > Â depends on NEW_LEDS
> >
> > EEEPC_WMI:
> > Â depends on ACPI_WMI
> > Â select LEDS_CLASS
> > Â select NEW_LEDS

Curious.

> > I don't really see how it's a recursive dependency, but maybe it's
> > time to clean this KConfig.
> > What is our current policy about that ?
> >
> > I think we should *depends* on important subsystem (ACPI, INPUT, ...)
> > and select obscure things so
> > that the driver does not get lost if you don't enable the leds.

I'm happy with that. Frankly, I don't want to care about LED, but...
 
> Wasn't all depends/selects to LEDS_CLASS outsourced by Johannes Berg
> to drivers/leds/Kconfig recently?

No, I just cleaned it up to make it not break builds and disallow
some weird configurations.

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
