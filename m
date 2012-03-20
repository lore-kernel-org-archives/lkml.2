Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852Ab2CTMMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:12:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63494 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2CTMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <1331931269-12262-2-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
	<1331931269-12262-2-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 20 Mar 2012 13:12:52 +0100
Message-ID: <CACRpkdYxhgh7AcQSJrRg4Nn4yY-+REdfK+ZXbDPs9E9b3s8goQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] pinctrl: Include <linux/bug.h> to prevent compile errors
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 9:54 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
> which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
> <linux/bug.h>. Include that so that every .c file using the pinctrl macros
> doesn't have to do that itself.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v2: Fix accidental replacing of pinctrl-state.h with pinctrl.h

Applied. Thanks!
Linus Walleij
