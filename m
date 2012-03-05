Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2CEKjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:39:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2CEKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:39:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
References: <1330718750-15217-1-git-send-email-swarren@nvidia.com>
Date: Mon, 5 Mar 2012 11:39:20 +0100
Message-ID: <CACRpkdaG=f_daGkXB56AxMOVej0gWj+cn6sjABLwOK17utQTaA@mail.gmail.com>
Subject: Re: [PATCH V3 0/7] pinctrl: API rework, pinconfig in mapping table, ...
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 9:05 PM, Stephen Warren <swarren@nvidia.com> wrote:

> This is the current set of patches I have outstanding for pinctrl.

It just works! So how could I possibly resist the temptation to
just apply all of this and push to for-next...

If me/Dong has some remaining issues with it we simply have to
fix that up ipso facto.

My U300 is happy anyways and the debugfs is really tasty, telling
me all I need to know.

So now I'll just adopt my driver(s) to support pinconfig in the
tables.

> NOTE: This series assumes that commit 7d23de2 "pinctrl: resurrect verbose
> pinmux-pins" is dropped, since "Show selected function and group in
> pinmux-pins debugfs" re-implements it in a way that's compatible with
> all the API rework and restructing in this series.

Yeah whatever, good-bye with that patch.

> The locking rework change is still under discussion; I haven't seen a
> nak/ack since I was asked to move it later in the series and I explained
> the difficulties in doing so while maintaining correctness.

Yeah whatever, I won't be stubborn with so much nice code coming
my way.

> The Tegra30 pinctrl driver fix should be OK to apply out-of-order if you
> want. I'd even be happy if you squashed it into the original commit that
> added the driver, if you branch doesn't need to be git-stable.

Oh I asked about that a few seconds ago, splendid. I just want to
make sure that e.g. Olof has not pulled the branch into ARM-SoC or
so...?

Yours,
Linus Walleij
