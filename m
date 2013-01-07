Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3AGMDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:03:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55673 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab3AGMD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:03:28 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Porter, Matt" <mporter@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dill, Russ" <russ.dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] da8xx: Allow use by am33xx based devices
Thread-Topic: [PATCH] da8xx: Allow use by am33xx based devices
Thread-Index: AQHNtsowjtEcnFNvskqiozVOiMWlCZfS2xNQgDjGJ3CABf8MAIADCEQAgAALTwCAKSN3kA==
Date: Mon, 7 Jan 2013 12:03:16 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA7FDD8@DBDE01.ent.ti.com>
References: <1351698968-3965-1-git-send-email-panto@antoniou-consulting.com>
 <A73F36158E33644199EB82C5EC81C7BC3EA1452B@DBDE01.ent.ti.com>
 <50C5A50E.4070602@ti.com>
 <A73F36158E33644199EB82C5EC81C7BC3EA17E45@DBDE01.ent.ti.com>
 <79CD15C6BA57404B839C016229A409A83EBADC10@DBDE01.ent.ti.com>
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EBADC10@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r07C3XkS026694

Hi,

On Wed, Dec 12, 2012 at 13:30:56, Hiremath, Vaibhav wrote:
> On Wed, Dec 12, 2012 at 12:50:28, Manjunathappa, Prakash wrote:

> > Agreed, should not result in build error. But is it ok to show this option
> > on the platforms which do not have this IP?
> > 
> 
> You can choose to put machine dependency here, as this patch is already 
> doing it. The side-effect of this would be, list may grow and you may have 
> to edit this file everytime.

It seems adding machine dependency is more in line with the
approach adopted in similar cases. As this IP is used only
in 2 arch's and would not in any immediate future go with
other arch's, it would be better not to ask other arch's a
question on whether this driver needs to be selected or not.

Regards
Afzal
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
