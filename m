Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab2D0DTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:19:07 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36142
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759665Ab2D0DTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:19:04 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 27 Apr 2012 11:28:37 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Zhao Richard-B20223 <B20223@freescale.com>
Subject: Re: [PATCH v4 1/4] dt: add of_get_child_count helper function
Message-ID: <20120427032831.GE26070@shlinux2.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <4F9976AB.1020502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F9976AB.1020502@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:24:11AM +0800, Stephen Warren wrote:
> On 04/26/2012 08:40 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Currently most code to get child count in kernel are almost same,
> > add a helper to implement this function for dt to use.
> 
> > diff --git a/include/linux/of.h b/include/linux/of.h
> 
> > +static inline int of_get_child_count(const struct device_node *np)
> > +{
> > +	struct device_node *child = NULL;
> 
> You don't actually need to initialize child here. It doesn't really
> matter here, but in a more complex function, it might hide a
> used-before-initialized error.
> 
Correct, i could change it.

Regards
Dong Aisheng

