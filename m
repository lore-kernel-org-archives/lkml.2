Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1KHK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:28:47 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31447 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750741Ab1KHK2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:28:46 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz9371K936eK542M1432N98dKzz1202hzz8275bh5e7bkz32i2a8h668h839h8e2h8e3h93fh64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:Outbound.kpitcummins.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>
Subject: RE: [Patch 04/11]Power: DA9052 battery driver v4
Thread-Topic: [Patch 04/11]Power: DA9052 battery driver v4
Thread-Index: AQHMngCEutyxg3yDjEiylnSJMi1HwJWixhbA
Date: Tue, 8 Nov 2011 10:28:44 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9BF2E2@KCHJEXMB02.kpit.com>
References: <1319033916.17688.41.camel@dhruva>
 <1320742364.9320.2.camel@dhruva>
 <20111108102307.GA25591@opensource.wolfsonmicro.com>
In-Reply-To: <20111108102307.GA25591@opensource.wolfsonmicro.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pA8ASsVj019806

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, November 08, 2011 3:53 PM
> To: Ashish Jangam
> Cc: linaro-dev@lists.linaro.org; cbou@mail.ru; dwmw2@infradead.org; linux-
> kernel@vger.kernel.org; Dajun
> Subject: Re: [Patch 04/11]Power: DA9052 battery driver v4
> 
> On Tue, Nov 08, 2011 at 02:22:44PM +0530, Ashish Jangam wrote:
> > On Wed, 2011-10-19 at 19:48 +0530, Ashish Jangam wrote:
> > > Driver for DA9052 battery charger. This driver depends on DA9052 MFD
> core dirver
> > > for definitions and methods.
> > >
> > > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > > ---
> > In case there are no review comments then can this be get ACK'ed?
> 
> The last time you posted this there was a serious issues with the MFD
> core which meant it didn't seem worth reviewing.
If MFD know looks good to you then please ACK it.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
