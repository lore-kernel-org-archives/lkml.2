Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1EXGwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:52:08 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:6608 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab1EXGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:52:05 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz9371O542M1432N98dKzz1202hzz6d523h8275bh5e7bkz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Tue, 24 May 2011 12:20:53 +0530
Subject: RE: [PATCHv3 11/11 ] ONKEY: Removed extra schedule call
Thread-Topic: [PATCHv3 11/11 ] ONKEY: Removed extra schedule call
Thread-Index: AcwZagB84NJZL7MKS422SAZathXciQAdICyQ
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BE826DD@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BDC3BBC@KCINPUNHJCMS01.kpit.com>
 <20110523165445.GD20397@core.coreip.homeip.net>
In-Reply-To: <20110523165445.GD20397@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4O6qILq032721

Hi Dmitry,

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Monday, May 23, 2011 10:25 PM
> To: Ashish Jangam
> Cc: linux-kernel@vger.kernel.org; Dajun Chen
> Subject: Re: [PATCHv3 11/11 ] ONKEY: Removed extra schedule call
> 
> Hi Ashish,
> 
> On Fri, May 20, 2011 at 03:10:47PM +0530, Ashish Jangam wrote:
> > Hi Dmitry,
> >
> > Delay time to query the power release button has been increased from 10ms to
> 50ms.
> > Removed extra schedule; now "onkey work" is called from the threaded irq
> itself.
> > Kconfig has been updated with the statement "To compile this module..."
> >
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > 		   David Dajun Chen <dajun.chen@diasemi.com>
> 
> This should be 2 separate signed-off-by lines, the first one by David
> and the 2nd one is yours. Otherwise:
Ok, this will be taken care of.
> 
> Acked-by: Dmitry Torokhov <dtor@mail.ru>
> 
> I assume it will be merged with the rest of DA9052 code through Samuel's
> MFD tree, right?
Yes. Since rest of the ack modules like LED, RTC will follow the same process of merging.
> 
> Thanks.
> 
> --
> Dmitry
Regards,
Ashish



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
