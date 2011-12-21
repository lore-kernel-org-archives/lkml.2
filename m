Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1LUDS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:18:28 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:25839
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab1LUDSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:18:24 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz9371I542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Topic: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
Thread-Index: AQHMvzz5RapTRp5ozEOP+dD9oHyS7ZXlzLaA///RbkA=
Date: Wed, 21 Dec 2011 03:18:19 +0000
Message-ID: <7FE21149F4667147B645348EC605788505C50F@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-2-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92EE2@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF176BE92EE2@HQMAIL01.nvidia.com>
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

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Wednesday, December 21, 2011 7:59 AM
> To: Dong Aisheng-B29396; linux-kernel@vger.kernel.org
> Cc: linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> rob.herring@calxeda.com; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; cjb@laptop.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [RFC PATCH v3 1/5] dt: add of_get_child_count helper function
> Importance: High
> 
> Dong Aisheng wrote at Tuesday, December 20, 2011 10:41 AM:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > Currently most code to get child count in kernel are almost same, add
> > a helper to implement this function for dt to use.
> 
> > diff --git a/include/linux/of.h b/include/linux/of.h
> 
> > +static inline int of_get_child_count(const struct device_node *np) {
> > +	return -ENOSYS;
> > +}
> 
> Wouldn't it be better to return 0 here? -ENOSYS would be fine if the function
> returned an error code, but it's really returning a count, and other "dummy"
> functions that return data return 0/NULL already. This would also allow you to
> just use the value directly in all cases rather than having to check for a < 0
> error case.
> 
Good point.
Will update it next.

Regards
Dong Aisheng


