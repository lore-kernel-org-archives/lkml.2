Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2H0Ncg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 09:32:36 -0400
Received: from portal.weinmann.de ([62.8.140.122]:31718 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2H0Nca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 09:32:30 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 09:32:30 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Yanes Martinez Adrian'" <adrian.yanes@aalto.fi>,
        "'ludovic.desroches'" <ludovic.desroches@atmel.com>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'balbi@ti.com'" <balbi@ti.com>,
        "'h.feurstein@gmail.com'" <h.feurstein@gmail.com>,
        "'rmallon@gmail.com'" <rmallon@gmail.com>,
        "'carsten.behling@garz-fricke.com'" <carsten.behling@garz-fricke.com>
Date: Mon, 27 Aug 2012 15:32:11 +0200
Subject: RE: [PATCH v11 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v11 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AQHNgDgewObqQrT3b0CsoUA7GPOztpdtR3KAgAA3EN7//+bnAIAAPHYwgAAMiwA=
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D090EC3D6F6@wm021.weinmann.com>
References: <cover.1345618760.git.n.voss@weinmann.de>
 <4f3dcfbf1e8eab3e251ab3558e9e1e9123643928.1345618760.git.n.voss@weinmann.de>,<503B4919.6080306@atmel.com>
 <BC0F374A1C27184AB96177CDFEC2F54225ECC330@EXMDB06.org.aalto.fi>,<503B623C.4030304@atmel.com>
 <BC0F374A1C27184AB96177CDFEC2F54225ECD36E@EXMDB06.org.aalto.fi>
In-Reply-To: <BC0F374A1C27184AB96177CDFEC2F54225ECD36E@EXMDB06.org.aalto.fi>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalId: qfq7RDWCqv003521
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adian,

Yanes Martinez Adrian wrote on Monday, August 27, 2012 2:46 PM:
> Le 08/27/2012 12:40 PM, Yanes Martinez Adrian a écrit :
>> Hi Ludovic,
>>
>>> Tested on at91rm9200, at91sam9261, at91sam9g20 and at91sam9m10 with
>>> eeprom, temperature sensor and rtc devices (and wolfson chip for
>>> sam9g20).
>>
>> concerning the at91rm9200, what was the amount of bytes you
> transmitted?
>>
> 
>> I have only checked that I can communicate with i2c devices so the
>> amount is very low (1-4 bytes).
> 
> IIRC it was from >7 bytes when the issues appeared.
> 
>> Some months ago I performed some testing[1] with the previous version of
>> the patch and the main conclusion was that the absence of PDC in the
>> AT91RM9200 made this driver unusable in such platform.

I didn't get your last post  in that thread. In my opinion RM9200 should really
be excluded from being configured with this driver, what's your opinion
Ludovic?

Regards,
Niko

