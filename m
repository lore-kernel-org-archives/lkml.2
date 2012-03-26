Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab2CZHAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:00:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51368 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab2CZHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <1332520186-23476-1-git-send-email-swarren@wwwdotorg.org>
References: <1332520186-23476-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 26 Mar 2012 09:00:12 +0200
Message-ID: <CACRpkdb1cp+A-b0hKUVyT_03hiLNTHm1qb=8xMUn-wk=UijO3g@mail.gmail.com>
Subject: Re: [PATCH V4] pinctrl: core device tree mapping table parsing support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linus.walleij@stericsson.com, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com, sjg@chromium.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 5:29 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> During pinctrl_get(), if the client device has a device tree node, look
> for the common pinctrl properties there. If found, parse the referenced
> device tree nodes, with the help of the pinctrl drivers, and generate
> mapping table entries from them.
>
> During pinctrl_put(), free any results of device tree parsing.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>

I really like this patch, nice clean and right to the point.

Can I have some more ACKs on it?

If no response in a day or two I'll apply it anyway just because
I like it.

Thanks Stephen,
Linus Walleij
