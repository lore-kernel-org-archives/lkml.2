Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2CESPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:15:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2580 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab2CESPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:15:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 05 Mar 2012 10:15:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 5 Mar 2012 10:15:06 -0800
Subject: RE: [PATCH V3 7/7] pinctrl: fix case of Tegra30's foo_groups[]
 arrays
Thread-Topic: [PATCH V3 7/7] pinctrl: fix case of Tegra30's foo_groups[]
 arrays
Thread-Index: Acz6u4FTH7xv6MtETka+pME5a2+EHQAQE2hg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861C5F@HQMAIL01.nvidia.com>
References: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
	<1330718750-15217-8-git-send-email-swarren@nvidia.com>
 <CACRpkdZY0d619UXcnXcq5_xJQdW9Y9M5gTPeVno2vDgSSucvqA@mail.gmail.com>
In-Reply-To: <CACRpkdZY0d619UXcnXcq5_xJQdW9Y9M5gTPeVno2vDgSSucvqA@mail.gmail.com>
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

Linus Walleij wrote at Monday, March 05, 2012 3:34 AM:
> On Fri, Mar 2, 2012 at 9:05 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > Tegra's pin groups all have lower-case names. Fix the foo_groups[] arrays
> > in the driver to be lower-case to match.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Applied this to my tegra-diet branch (the one with just the driver and
> not board file changes).
> 
> Can I squash it with the patch that introduce the capitalized names
> so as to avoid pointless churn?

Absolutely, thanks.

(I'd suggested doing just that in patch 0, but not in the patch itself)

-- 
nvpublic

