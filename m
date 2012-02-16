Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2BPTBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:01:23 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12336 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2BPTBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:01:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 16 Feb 2012 11:01:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Thu, 16 Feb 2012 11:01:17 -0800
Subject: RE: [PATCH] serial/sirf: fixup for changes to pin control
Thread-Topic: [PATCH] serial/sirf: fixup for changes to pin control
Thread-Index: Aczs2vfEPBF+96NhRmefQf8gIGJbpAAAf4Dw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1790EC8791@HQMAIL01.nvidia.com>
References: <1329417828-6005-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1329417828-6005-1-git-send-email-linus.walleij@linaro.org>
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

Linus Walleij wrote at Thursday, February 16, 2012 11:44 AM:
> We changed the signature of the pin multiplexing functions to
> handle any pin business, so fix up the Sirf driver to call this
> new interface and rename some variables to make the semantics
> understandable.
> 
> Cc: linux-serial@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Looks good to me for now.

I'll have to do another similar change when I implement the pinctrl_get
API changes we discussed at Linaro Connect (I should start implementing
that today), but I guess that's no big deal.

Should this patch be put into the pinctrl tree since that's where the
API changed, perhaps even squashed into the original commit to avoid
git bisect breakage, unless your branch needs to be stable? Otherwise,
this change will conflict with my future similar change if pulled for
the same kernel version.

-- 
nvpublic

