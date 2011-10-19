Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1JSSWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:22:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14594 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1JSSWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:22:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 19 Oct 2011 11:22:06 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
CC: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 19 Oct 2011 11:22:03 -0700
Subject: RE: [PATCH 1/2] pinctrl: move group lookup to core
Thread-Topic: [PATCH 1/2] pinctrl: move group lookup to core
Thread-Index: AcyOeynD89lp6oo2Q9acW2q6p+nqvQAEMWXA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173D51BEE1@HQMAIL01.nvidia.com>
References: <1319041266-18690-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1319041266-18690-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, October 19, 2011 10:21 AM:
> Now also the core needs to look up pin groups so move the lookup
> function there and expose it in the internal header.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

