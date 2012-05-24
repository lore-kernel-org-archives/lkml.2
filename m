Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2EXA3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:29:16 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:14460
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab2EXA3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:29:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 24 May 2012 08:48:52 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, <marc@cpdesign.com.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524004851.GB7843@S2100-06.ap.freescale.net>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
 <20120523164203.GA7843@S2100-06.ap.freescale.net>
 <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 01:34:32PM -0300, Fabio Estevam wrote:
> On Wed, May 23, 2012 at 1:42 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> 
> > Removing that alone does not resolve the issue, but with additional
> > .write_flag_mask setting it does for me.
> 
> This is still not working for me on mx31pdk.
> 
> Still getting wrong SPI read data from the pmic.
> 
Interesting.

I'm booting my imx51 babbage with MC13892 with no problem now.  And
reading the registers give me the same values as I do with u-boot.

Regards,
Shawn

root@linaro-developer:~# cat /sys/kernel/debug/regmap/spi32766.0/registers
00: 005c80
01: ffffff
02: 195448
03: 000081
04: ffffff
05: 00401c
06: 000218
07: 0045d0
08: 000000
09: 000000
0a: 000001
0b: 000000
0c: 000000
0d: 000040
0e: 000000
0f: 400000
10: 000000
11: 000000
12: 000000
13: 000000
14: 0003af
15: 01ffff
16: 000000
17: 007fff
18: 454a54
19: 45673a
1a: 00631a
1b: 80739c
1c: 212048
1d: 000808
1e: 010fe0
1f: 0001f4
20: 049208
21: 049249
22: 200000
23: 000000
24: 000000
25: 000000
26: 000000
27: 000000
28: 000000
29: 000000
2a: 000000
2b: 008000
2c: 000000
2d: 574574
2e: 0001c0
2f: 055055
30: 60007b
31: 000040
32: 000008
33: 000000
34: 000000
35: 000000
36: 000000
37: 000000
38: 000000
39: 000000
3a: 000000
3b: 000000
3c: 000000
3d: 000000
3e: 000000
3f: 000000

