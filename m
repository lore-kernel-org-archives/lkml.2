Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2HTRk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:40:59 -0400
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:33814 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2HTRk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:40:56 -0400
X-Greylist: delayed 750 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2012 13:40:56 EDT
From: Kevin Wells <kevin.wells@nxp.com>
To: Roland Stigge <stigge@antcom.de>, Wolfram Sang <w.sang@pengutronix.de>
CC: "vitalywool@gmail.com" <vitalywool@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Bakki <srinivas.bakki@nxp.com>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Date: Mon, 20 Aug 2012 18:26:54 +0200
Subject: RE: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
Thread-Topic: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
Thread-Index: Ac1950Ndnw0RHbdpTAGeI339V6MF0ABAa4/A
Message-ID: <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com>
References: <1344411752-23469-1-git-send-email-stigge@antcom.de>
 <20120818095108.GB24812@pengutronix.de> <5030A81E.5090508@antcom.de>
In-Reply-To: <5030A81E.5090508@antcom.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7KHf4Hf014636

>>> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx,
>>> not yet in mainline). Can you please test and double-check the
>>> manuals of PNX4008 and LPC31xx? I only found this via the manual
>>> of LPC32xx but assume it's the same for the others, also.
>>> 
>>> Thanks in advance!
>> 
>> Kevin, since the other manuals seem to be not easily available, can
>> you please check?
>
>Yes, would be great if someone at NXP could confirm that PNX actually
>uses the same IP core for the I2C controller as LPCs do (which is
>currently assumed by Linux anyway).

I've never had my hands on a PNX4008 chip at NXP, but I do believe they
are the same IP. That specific I2C IP was used in a number of NXP/Phillips
chips besides the PNX4008/LPC32xx. I don't think there are any PNX4008's in
the wild, and even working in NXP, I can't find any non-marketing reference
material for that part (including the user manual).

The pnx I2C block is used in the LPC32xx (3 instances), the LPC313x,
LPC2000 (1 instance for USB OTG), and the LPC17xx/LPC40xx (1 instance for
USB OTG). The LPC2000, LPC17xx, and LPC40xx devices also use another
completely different (non-pnx) I2C block for non-OTG I2C.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
