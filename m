Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031021Ab2CNV01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:26:27 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:21146 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030915Ab2CNV0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:26:23 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dPFxNjZJd/jLUPvV1BWMw
Date: Wed, 14 Mar 2012 14:26:16 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
Message-ID: <20120314212616.GR12083@atomide.com>
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [120309 10:17]:
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

Great, looks good to me:

Acked-by: Tony Lindgren <tony@atomide.com>
