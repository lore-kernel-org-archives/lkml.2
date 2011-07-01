Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1GAL16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:27:58 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:53670
	"EHLO CH1EHSOBE016.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755199Ab1GAL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:27:57 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz9371M4015L542M1432N98dKzz1202hzz8275bh8275dhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Fri, 1 Jul 2011 16:57:55 +0530
Subject: RE: [PATCH 6/11] HWMON: DA9052 hwmon driver v2
Thread-Topic: [PATCH 6/11] HWMON: DA9052 hwmon driver v2
Thread-Index: Acw3MSlS2BYM5MldSLir4rJ4RzCx7wAsLGlg
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D152F0185F5@KCINPUNHJCMS01.kpit.com>
References: <1309439728.4656.0.camel@L-0532.kpit.com>
 <20110630142219.GA13161@ericsson.com>
In-Reply-To: <20110630142219.GA13161@ericsson.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p61BS86S001129


> -----Original Message-----
> From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> Sent: Thursday, June 30, 2011 7:52 PM
> To: Ashish Jangam
> Cc: randy.dunlap@oracle.com; linaro-dev@lists.linaro.org; dchen@diasemi.com;
> linux-kernel@vger.kernel.org; lm-sensors@lm-sensors.org
> Subject: Re: [PATCH 6/11] HWMON: DA9052 hwmon driver v2
> 
> On Thu, Jun 30, 2011 at 09:15:27AM -0400, ashishj3 wrote:
> > The DA9052 PMIC provides an Analogue to Digital Converter with 10 bits
> > resolution and 10 channels.
> >
> > This patch montiors the DA9052 PMIC's ADC channels mostly for battery
> parameters
> > like battery temperature, junction temperature, battery current etc.
> >
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> I assume this patch will be handled as part of a patchset, correct ?
Correct.
> 
> Thanks,
> Guenter



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
