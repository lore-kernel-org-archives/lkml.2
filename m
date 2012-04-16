Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2DPHki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:40:38 -0400
Received: from portal.weinmann.de ([62.8.140.122]:3156 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2DPHkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:40:36 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 03:40:36 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'dgilbert@interlog.com'" <dgilbert@interlog.com>,
        "'Jean Delvare'" <khali@linux-fr.org>
CC: "'Linux I2C'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>
Date: Mon, 16 Apr 2012 09:40:11 +0200
Subject: RE: [PATCH] i2c-dev: Add support for I2C_M_RECV_LEN
Thread-Topic: [PATCH] i2c-dev: Add support for I2C_M_RECV_LEN
Thread-Index: Ac0UF2FxSngN9v4SS4uhM7Xkf1VKZAHi3YJA
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D0905D5A1D2@wm021.weinmann.com>
References: <20120315180835.2e669111@endymion.delvare>
 <20120331081927.2438ea9e@endymion.delvare> <4F7CD11C.2090801@interlog.com>
 <20120405092422.453edecf@endymion.delvare> <4F7E3267.9040306@interlog.com>
 <20120406083751.46fd23c5@endymion.delvare> <4F7F16D3.6080307@interlog.com>
 <20120406182534.68d7f53d@endymion.delvare> <4F7F2220.50003@interlog.com>
In-Reply-To: <4F7F2220.50003@interlog.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Douglas Gilbert wrote on 2012-04-06:
> On 12-04-06 12:25 PM, Jean Delvare wrote:
>> On Fri, 06 Apr 2012 12:16:19 -0400, Douglas Gilbert wrote:
>>> However I see that Nikolaus Voss has submitted a replacement driver
>>> for the i2c-at91 that works for the G45 which has two TWI units.
>>> Is that driver going into the mainline? Surely it is much better
>>> than the broken i2c-at91 driver that has been sitting broken for
>>> way too long. Atmel are bringing out new MCUs in that family which
>>> have 3 TWI units (e.g. AT91SAM9G25). Apart from the limitations
>>> about repeated starts surely Atmel have fixed the problems referred
>>> to in existing mainline i2c-at91.c driver from circa 2006.
>>> 
>>> My vote would be to add Nikolaus Voss's driver ASAP.
>> 
>> I'm not into embedded devices, so this isn't my call.
> 
> A pity. I checked lk 3.4-rc1 and the bad old driver is still there.

as I see it, my driver has only been tested with the G45. If you
can confirm it works with other devices, too, maybe this would help
to get it into next.

Niko

