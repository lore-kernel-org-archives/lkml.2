Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2BXGSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:18:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2BXGSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:18:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.202.97 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1330041880-12406-3-git-send-email-swarren@nvidia.com>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
	<1330041880-12406-3-git-send-email-swarren@nvidia.com>
Date: Fri, 24 Feb 2012 07:18:32 +0100
Message-ID: <CACRpkdZarAxuJv=qpHd3aLAf99Lyw88F1KCwSjg2z04Tftdx7w@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: Move pinctrl-maps debugfs file to top-level
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

On Fri, Feb 24, 2012 at 1:04 AM, Stephen Warren <swarren@nvidia.com> wrote:

> The debugfs file pinctrl-maps is a system-wide file, not specific to any
> pin controller, so place it in the top-level directory.
>
> Also, move the code implementing the file to keep the order of all the
> functions matching the order they're created in pinctrl_init_*debugfs().
> The only non-obvious change here is no private data is passed to
> debugfs_create_file() or single_open().
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Obviously correct, thanks, applied with Dong's ACK.

Yours,
Linus Walleij
