Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab0GONor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 09:44:47 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:57788 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200Ab0GONoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 09:44:46 -0400
X-IronPort-AV: E=Sophos;i="4.55,208,1278302400"; 
   d="scan'208";a="19335866"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Frysinger, Michael" <Michael.Frysinger@analog.com>
Date: Thu, 15 Jul 2010 14:44:41 +0100
Subject: EXPORT_SYMBOL set_irq_noprobe, set_irq_chip_and_handler,
 irq_to_desc ?
Thread-Topic: EXPORT_SYMBOL set_irq_noprobe, set_irq_chip_and_handler,
 irq_to_desc ?
Thread-Index: AcskI+BsaY38LvbOTaCJIQz8wtUhUA==
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E7EA5A21C@LIMKCMBX1.ad.analog.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We added some irq_chip functionality to the ADP5588 GPIO driver.
I wonder whether these symbol should be better exported or not?

ERROR: "set_irq_noprobe" [drivers/gpio/adp5588-gpio.ko] undefined!
ERROR: "set_irq_chip_and_handler" [drivers/gpio/adp5588-gpio.ko] undefined!
ERROR: "irq_to_desc" [drivers/gpio/adp5588-gpio.ko] undefined!

Some other drivers avoid the same issue by preventing the driver being built as module.
Is that the way to go?

Best regards,
Michael

------------------------------------------------------------------
********* Analog Devices GmbH              Open Platform Solutions
**  *****
**     ** Wilhelm-Wagenfeld-Strasse 6
**  ***** D-80807 Munich
********* Germany
Registergericht München HRB 40368,  Geschäftsführer: Thomas Wessel, William A. Martin, Margaret K. Seif

