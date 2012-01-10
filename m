Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2AJK4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:56:04 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:29105
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab2AJK4C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:56:02 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202hzzz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Zhao Richard-B20223 <B20223@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Richard Zhao <richard.zhao@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Thread-Topic: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Thread-Index: AQHMvz054UU1JnMzAU21AJwvxWDckZYC8pAAgADazYCAAAJKgIAAR0oAgAG1roCAACLbAP//nljQ
Date: Tue, 10 Jan 2012 10:55:59 +0000
Message-ID: <7FE21149F4667147B645348EC605788508B006@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
	<1324402840-32451-4-git-send-email-b29396@freescale.com>
	<20120108130542.GC2203@richard-laptop>
	<20120109020848.GF1835@S2101-09.ap.freescale.net>
	<20120109021702.GV2414@b20223-02.ap.freescale.net>
	<20120109063136.GI1835@S2101-09.ap.freescale.net>
	<20120110083842.GA2414@b20223-02.ap.freescale.net>
 <CACRpkdZ=G+=Aq49r9VYa1ZGMg=Sy3Dy3kHNbbcFRp-Hn6y1ZqQ@mail.gmail.com>
In-Reply-To: <CACRpkdZ=G+=Aq49r9VYa1ZGMg=Sy3Dy3kHNbbcFRp-Hn6y1ZqQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Next from discussions with Stpehen I've sort of figured out that we need a
> config mapping table of sorts and then a means to activate entries of that table
> at runtime. I'm trying to come up with something for this.
> 
Good to hear this.
I did not catch up your steps before, so I did not give much comment on the pinctrl core.
I would try to do it if I can now.

Regards
Dong Aisheng

