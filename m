Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2DAR3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:29:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44036 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2DAR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <1332265479-1260-6-git-send-email-swarren@wwwdotorg.org>
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
	<1332265479-1260-6-git-send-email-swarren@wwwdotorg.org>
Date: Sun, 1 Apr 2012 19:29:19 +0200
Message-ID: <CACRpkdav8x-Td-fH1Ree83GhNR8r7aA1dBsTQo2eU3nwwam21Q@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] pinctrl: tegra: Add complete device tree support
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

On Tue, Mar 20, 2012 at 6:44 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
> complete specification of the desired pinmux configuration using device
> tree.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v2: Rebase on of_property_for_each_string() API changes.

Stephen is this eligible for merge? Or does it need changes on top
of the v4 core patch?

Yours,
Linus Walleij
