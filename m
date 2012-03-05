Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2CESZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:25:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4160 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab2CESZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:25:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 05 Mar 2012 10:25:15 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 5 Mar 2012 10:25:14 -0800
Subject: RE: [PATCH V3 0/7] pinctrl: API rework, pinconfig in mapping table,
 ...
Thread-Topic: [PATCH V3 0/7] pinctrl: API rework, pinconfig in mapping
 table, ...
Thread-Index: Acz6vDnqxawzQ3UzT325RatLyylmNgAQKESg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861C68@HQMAIL01.nvidia.com>
References: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
 <CACRpkdaG=f_daGkXB56AxMOVej0gWj+cn6sjABLwOK17utQTaA@mail.gmail.com>
In-Reply-To: <CACRpkdaG=f_daGkXB56AxMOVej0gWj+cn6sjABLwOK17utQTaA@mail.gmail.com>
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

Linus Walleij wrote at Monday, March 05, 2012 3:39 AM:
> On Fri, Mar 2, 2012 at 9:05 PM, Stephen Warren <swarren@nvidia.com> wrote:
...
> > The Tegra30 pinctrl driver fix should be OK to apply out-of-order if you
> > want. I'd even be happy if you squashed it into the original commit that
> > added the driver, if you branch doesn't need to be git-stable.
> 
> Oh I asked about that a few seconds ago, splendid. I just want to
> make sure that e.g. Olof has not pulled the branch into ARM-SoC or
> so...?

Not pulled yet (I just confirmed in both repos).

There was a plan to pull that branch into the Tegra tree to base some
arch/arm/mach-tegra changes on it, but that got deferred while I redid
those Tegra patches on top of latest pinctrl, and I haven't posted the
updated Tegra patches yet, and hence your branch didn't get pulled in
yet.

At this point, we'll probably just wait for latest pinctrl to show up
In 3.4 and apply the Tegra patches on top of that rather than merging
your branch.

-- 
nvpublic

