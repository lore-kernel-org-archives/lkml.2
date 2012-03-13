Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2CMEMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:12:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64405 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2CMEMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:12:52 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        Stephen Warren <swarren@wwwdotorg.org>
In-Reply-To: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 12 Mar 2012 22:12:48 -0600
Message-Id: <20120313041248.C470C3E0536@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Mar 2012 11:14:33 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> The core pin controller bindings define:
> * The fact that pin controllers expose pin configurations as nodes in
>   device tree.
> * That the bindings for those pin configuration nodes is defined by the
>   individual pin controller drivers.
> * A standardized set of properties for client devices to define numbered
>   or named pin configuration states, each referring to some number of the
>   afore-mentioned pin configuration nodes.
> * That the bindings for the client devices determines the set of numbered
>   or named states that must exist.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>

Not reviewed this version deeply, but this looks good to me.  Feel free
to merge it if both you and Linus are happy with it.

g.

