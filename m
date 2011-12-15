Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1LOFt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:49:58 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:52048
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab1LOFt5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:49:57 -0500
X-SpamScore: -21
X-BigFish: VS-21(zzbb2dI9371I1447M542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH v2 1/4] dt: add of_get_child_number helper function
Thread-Topic: [RFC PATCH v2 1/4] dt: add of_get_child_number helper function
Thread-Index: AQHMuniMNBJVHF9vuECCwPUYFr+qmpXcBUgAgAA8gYCAACPJMA==
Date: Thu, 15 Dec 2011 05:49:54 +0000
Message-ID: <7FE21149F4667147B645348EC6057885053036@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
 <1323878622-26602-2-git-send-email-b29396@freescale.com>
 <4EE8E52C.1030506@gmail.com>
 <CACxGe6tQO=5oGXjpZ_VD+Pzs+mPKgdciKBHiA6YBf4PHfe_Q7g@mail.gmail.com>
In-Reply-To: <CACxGe6tQO=5oGXjpZ_VD+Pzs+mPKgdciKBHiA6YBf4PHfe_Q7g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of
> Grant Likely
> Sent: Thursday, December 15, 2011 5:41 AM
> To: Rob Herring
> Cc: Dong Aisheng-B29396; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linus.walleij@stericsson.com;
> s.hauer@pengutronix.de; Guo Shawn-R65073; kernel@pengutronix.de
> Subject: Re: [RFC PATCH v2 1/4] dt: add of_get_child_number helper
> function
> Importance: High
> 
> On Wed, Dec 14, 2011 at 11:04 AM, Rob Herring <robherring2@gmail.com>
> wrote:
> > Dong,
> >
> > On 12/14/2011 10:03 AM, Dong Aisheng wrote:
> >> From: Dong Aisheng <dong.aisheng@linaro.org>
> >>
> >> Currently most code to get child number in kernel are almost same,
> >> add a helper to implement this function for dt to use.
> >>
> >> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> >> Cc: Grant Likely <grant.likely@secretlab.ca>
> >> Cc: Rob Herring <rob.herring@calxeda.com>
> >> ---
> >>  include/linux/of.h |   17 +++++++++++++++++
> >>  1 files changed, 17 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/include/linux/of.h b/include/linux/of.h index
> >> 4948552..09d53dc 100644
> >> --- a/include/linux/of.h
> >> +++ b/include/linux/of.h
> >> @@ -189,6 +189,18 @@ extern struct device_node
> >> *of_get_next_child(const struct device_node *node,
> >>       for (child = of_get_next_child(parent, NULL); child != NULL; \
> >>            child = of_get_next_child(parent, child))
> >>
> >> +static inline int of_get_child_number(struct device_node *np)
> >
> > I would call this of_get_child_count instead.
> 
> I agree.
> 
Yes, will change to that name.
Thanks for the suggestion.

Regards
Dong Aisheng


