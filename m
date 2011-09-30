Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab1I3SIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:08:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19496 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab1I3SIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:08:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 Sep 2011 11:08:46 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>
CC: Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stijn Devriendt <highguy@gmail.com>
Date: Fri, 30 Sep 2011 11:08:44 -0700
Subject: RE: [PATCH] drivers: create a pin control subsystem v8
Thread-Topic: [PATCH] drivers: create a pin control subsystem v8
Thread-Index: Acx91swYFc+wrvp4QIiXTlfEKpgXmABxQvWw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6A63@HQMAIL01.nvidia.com>
References: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1317211419-18472-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, September 28, 2011 6:04 AM:
> This creates a subsystem for handling of pin control devices.
> These are devices that control different aspects of package
> pins.

I still haven't had a chance to look through the .c files, just the docs
and headers, but they look good to me now, so:

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

