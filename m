Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2D0Msj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:48:39 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:37781
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757271Ab2D0Msi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:48:38 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:220.225.38.51;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: RE: [Patch] Touch: DA9052/53 touch screen driver v2
Thread-Topic: [Patch] Touch: DA9052/53 touch screen driver v2
Thread-Index: AQHNH4lk4PQTk97+3kOpYk3/p0Sjd5aqAgtQgASmGnA=
Date: Fri, 27 Apr 2012 12:46:52 +0000
Message-ID: <C3AE124F08223B42BC95AEB82F0F6CED2D562697@KCHJEXMB02.kpit.com>
References: <1334924925.3752.14.camel@dhruva>
 <20120421063855.GA2360@core.coreip.homeip.net> 
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.38.22]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Fri, Apr 20, 2012 at 05:58:45PM +0530, Ashish Jangam wrote:
> > Why did you switch to using irq_base here? da9052_onkey driver does not
> > do that, should it?
> On i.mx53 loco board irq_base was required so to keep driver working across
> boards this was introduced. Need to fix this in onkey driver.
> >
> > Thanks.
If the patch looks good then please ACK it. 

