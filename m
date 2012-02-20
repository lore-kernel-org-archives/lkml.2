Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2BTVvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:51:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59816 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2BTVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:51:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.179.8 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:51:30 +0100
Message-ID: <CACRpkdah8z2igdEgMee-ACBsLKgtfu1qij5wzCZ5wkva83qmrQ@mail.gmail.com>
Subject: Re: [PATCH 00/20] pinctrl: API change, config in mapping table
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK I got to patch 10 tonight, so I applied these to for-next
and pushed:

3a4de0b pinctrl: core.c/h cleanups
144e2bb pinctrl: Re-order pinconf.[ch] to match each-other
dd36982b pinctrl: Re-order pinmux.[ch] to match each-other
7dbf763 pinctrl: Store mapping table as a list of chunks
78917f6 pinctrl: use list_add_tail instead of list_add
9c8484d pinctrl: pinctrl_register_mappings() shouldn't be __init

Will continue reviewing tomorrow.

Thanks,
Linus Walleij
