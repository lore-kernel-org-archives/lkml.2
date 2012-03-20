Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab2CTMO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:14:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36267 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab2CTMOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <1331931269-12262-4-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
	<1331931269-12262-4-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 20 Mar 2012 13:14:24 +0100
Message-ID: <CACRpkdY4gStxWTRXnpAPj8ko3d5Cr9N4OGanFWJDt-O-psOFeg@mail.gmail.com>
Subject: Re: [PATCH 4/8] pinctrl: implement pinctrl_check_ops
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

> Most code assumes that the pinctrl ops are present. Validate this when
> registering a pinctrl driver. Remove the one place in the code that
> was checking whether one of these non-optional ops was present.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>

Good idea, applied.

Yours,
Linus Walleij
