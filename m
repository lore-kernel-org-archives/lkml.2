Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030699Ab2ERClN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:41:13 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:4948 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030509Ab2ERClK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:41:10 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Thu, 17 May 2012 22:41:21 -0400
Subject: RE: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing
 I2C transfer if MEN bit is reset unexpectedly.
Thread-Topic: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing
 I2C transfer if MEN bit is reset unexpectedly.
Thread-Index: Ac00IJok9/SGUKUVTUyzdjR5Iv6MTAAfuXrg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F64F8527E@NWD2CMBX1.ad.analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-4-git-send-email-sonic.zhang@analog.com>
 <CAM=Q2cta_a2XcOLoOnnUUjZOpj1phUH99xfgZnh4nhxG8QX3-Q@mail.gmail.com>
In-Reply-To: <CAM=Q2cta_a2XcOLoOnnUUjZOpj1phUH99xfgZnh4nhxG8QX3-Q@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
>Sent: Thursday, May 17, 2012 7:31 PM
>To: Zhang, Sonic
>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-dist-
>devel@blackfin.uclinux.org
>Subject: Re: [PATCH 4/8] i2c: i2c-bfin-twi: Tighten condition when failing I2C
>transfer if MEN bit is reset unexpectedly.
>
>On Wed, May 16, 2012 at 12:50 PM,  <sonic.zhang@analog.com> wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Correct I2C transfer may fail because interrupt status bits XMTSERV and
>> RCVSERV are not checked when MCOMP interrupt is handled.
>>
>Could you expand MCOMP?

Master transfer complete (MCOMP)
[1] The initiated master transfer has completed. In the absence of a
repeat start, the bus has been released.
[0] The completion of a transfer has not been detected.


Regards,

Sonic

