Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1KIRx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:53:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6471 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1KIRxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:53:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Nov 2011 09:53:17 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
CC: Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 9 Nov 2011 09:53:16 -0800
Subject: RE: [PATCH v2] pinctrl: hide subsystem from the populace
Thread-Topic: [PATCH v2] pinctrl: hide subsystem from the populace
Thread-Index: Acye6cbh3Rh4KlR1SM28R9t+S+fTQgAHp+zA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174080511F@HQMAIL01.nvidia.com>
References: <1320847976-13579-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1320847976-13579-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, November 09, 2011 7:13 AM:
> Machines that have embedded pin controllers need to select them
> explicitly, so why broadcast their config options to menuconfig.
> We provide a helpful submenu for those machines that do select
> it, making it possible to enable debugging for example.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

