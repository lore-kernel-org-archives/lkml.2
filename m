Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161125Ab2CORNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:13:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45188 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031976Ab2CORND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:13:03 -0400
Message-ID: <4F622319.5060402@wwwdotorg.org>
Date: Thu, 15 Mar 2012 11:12:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>	<20120314212616.GR12083@atomide.com> <CACRpkdY9Hi84KOESr1R94PNpvAPn7aMKE4kUcG-O6FMaX84qAA@mail.gmail.com>
In-Reply-To: <CACRpkdY9Hi84KOESr1R94PNpvAPn7aMKE4kUcG-O6FMaX84qAA@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 10:51 AM, Linus Walleij wrote:
...
> Hm, both you guys agree, then I will be happy that we merge this.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Great. I'll repost a new version very soon based on the feedback (just a
couple of grammar issues and an added example).

> Since it's just toching DT dirs I guess it should go through Grant,
> but I'm happy to take it in pinctrl too.

I've seen many bindings go through the tree for the subsystem they
correspond to, as part of the series that implements them. I'm not
bothered either way though - I'll let you work this out with Grant once
I post the final version.

(I'm hoping to post the actual implementation today, maybe tomorrow)
