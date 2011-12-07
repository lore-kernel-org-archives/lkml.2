Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab1LGFZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 00:25:53 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:57931 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1LGFZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 00:25:52 -0500
X-SpamScore: -14
X-BigFish: VS-14(zzc89bh542M1432N98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sun york-R58495 <R58495@freescale.com>,
        Durai Kumar-R34055 <r34055@freescale.com>,
        Huang Changming-R66093 <r66093@freescale.com>
Subject: RE: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMpIUnsb9+I0lR9k+0uRq1j4EoUpWwJ/0AgAAFb4CAAAQAAIAAAwAAgAAOBACAAAE+gIAAAP2AgB+Fq4CAAG9pAP//s6FA
Date: Wed, 7 Dec 2011 05:25:49 +0000
Message-ID: <3C06C26914DACA4BB3A368F78CA0B3A71345F2@039-SN1MPN1-004.039d.mgd.msft.net>
References: <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
 <1321464509.7847.41.camel@oslab-l1>
 <1321464968.2309.384.camel@groeck-laptop>
 <1321466135.7847.55.camel@oslab-l1>
 <20111116190954.67c846fc@endymion.delvare>
 <1321467638.7847.73.camel@oslab-l1>
 <20111116201048.4b7877dd@endymion.delvare>
 <1321470915.7847.122.camel@oslab-l1>
 <20111116201847.6b11dc7f@endymion.delvare>
 <3C06C26914DACA4BB3A368F78CA0B3A7134583@039-SN1MPN1-004.039d.mgd.msft.net>
 <20111207032000.GA17575@ericsson.com>
In-Reply-To: <20111207032000.GA17575@ericsson.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.75]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB75Q4Mk019365

Hi Guenter,

I thought you were bore of discussion.
Do you mind if I post similar patch?

Regards,
Yuantian

> -----Original Message-----
> From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> Sent: 2011å¹´12æœˆ7æ—¥ 11:20
> To: Tang Yuantian-B29983
> Cc: Jean Delvare; Tabi Timur-B04825; linux-i2c@vger.kernel.org; linux-
> kernel@vger.kernel.org; sun york-R58495; Durai Kumar-R34055; Huang
> Changming-R66093
> Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> SMBUS_READ_BLOCK_DATA
> 
> On Tue, Dec 06, 2011 at 09:52:36PM -0500, Tang Yuantian-B29983 wrote:
> > Hi Jean Delvare,
> >
> > We agree to apply this patch. Do you have any concerns?
> > Although Guenter said that he give up, I don't think he really meant it.
> 
> I did mean it, otherwise I would not have said it.
> 
> Guenter
> 
> > Also it is improper if I repost similar patch.
> > I tested this patch, it works.
> >
> > Regards,
> > Yuantian
> >
> > > -----Original Message-----
> > > From: Jean Delvare [mailto:khali@linux-fr.org]
> > > Sent: 2011å¹´11æœˆ17æ—¥ 3:19
> > > To: sun york-R58495
> > > Cc: guenter.roeck@ericsson.com; Tabi Timur-B04825; linux-
> > > i2c@vger.kernel.org; linux-kernel@vger.kernel.org; Tang
> > > Yuantian-B29983
> > > Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> > > SMBUS_READ_BLOCK_DATA Really, please. I understand you're only
> > > trying to help and understand the patch, but at some point, if you
> > > have zero knowledge about the topic, you're not the right person to
> > > review the patch, period. You are still welcome to test the patch if
> > > you can and want, that's a completely different task.
> > >
> > > --
> > > Jean Delvare
> >
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
