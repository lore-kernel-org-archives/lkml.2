Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab1KRKEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:04:45 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:52698
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756535Ab1KRKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:04:44 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz9371K936eK542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h93fh)
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: RE: [PATCH 1/11] MFD: DA9052 MFD core module v8
Thread-Topic: [PATCH 1/11] MFD: DA9052 MFD core module v8
Thread-Index: AQHMpdhedK85SV2zTE26Wdc+DoHCHJWyZW9A
Date: Fri, 18 Nov 2011 10:00:59 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED1F9C5F05@KCHJEXMB01.kpit.com>
References: <1320300865.2092.10.camel@dhruva>
 <1321610190.20271.328.camel@x61.thuisdomein>
In-Reply-To: <1321610190.20271.328.camel@x61.thuisdomein>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAIA4rQJ009640

> -----Original Message-----
> From: Paul Bolle [mailto:pebolle@tiscali.nl]
> Sent: Friday, November 18, 2011 3:27 PM
> To: Ashish Jangam
> Cc: Mark Brown; arnd@arndb.de; sameo@openedhand.com; linux-
> kernel@vger.kernel.org; Dajun; linaro-dev@lists.linaro.org
> Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v8
> 
> On Thu, 2011-11-03 at 11:44 +0530, Ashish Jangam wrote:
> > The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> > flexibility to support wide range of high performance application.
> >
> > It provides voltage regulators, GPIO controller, Touch Screen, RTC,
> Battery
> > control and other functionality.
> >
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> 
> So the DA9052 GPIO module that is currently in the mainline tree was
> added as unbuildable code, wasn't it?
DA9052 MFD has undergone changes even after ack of DA9052 GPIO so with
the current MFD it may not work. Now once MFD gets through I will send an
incr patch for DA9052 GPIO. 
> 
> 
> Paul Bolle
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
