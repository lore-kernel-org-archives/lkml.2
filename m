Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1AaDht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 22:37:49 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35985 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab1AaDhs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 22:37:48 -0500
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.miao@linaro.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Hemanth V <hemanthv@ti.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Bill Gatliff <bgat@billgatliff.com>
Date: Mon, 31 Jan 2011 04:35:33 +0100
Subject: RE: [RFC] add pwmlib support
Thread-Topic: [RFC] add pwmlib support
Thread-Index: Acu/9nejxmQiTWTSTA+ooSsu1+LZlgBAI/mQ
Message-ID: <F45880696056844FA6A73F415B568C6953739F1986@EXDCVYMBSTM006.EQ1STM.local>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
 <4D447E5E.6060007@metafoo.de>
In-Reply-To: <4D447E5E.6060007@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

> > I Cced the people working with PWMs in the kernel in the hope that
> they can
> > give input on what's missing / wrong in this implementation
> >
> > Sascha
> >
> 
> Hi
> 
> There have been two other proposals for a generic PWM api during the
> last year.
> You might want to take a look at them.
> 
> https://lkml.org/lkml/2010/2/9/275
> https://lkml.org/lkml/2010/9/28/107
> 
> I've added Bill Gatliff and Arun Murthy to Cc.
> 

As said by Lars, we already have developed the pwm core driver and
progressing towards aligning the existing pwm drivers to the pwm core
driver.
These set of patches are expected to be out in LKML by this week.

Thanks and Regards,
Arun R Murthy
------------
