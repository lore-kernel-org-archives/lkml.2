Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161058Ab2COQvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:51:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56177 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044Ab2COQvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120314212616.GR12083@atomide.com>
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org>
	<20120314212616.GR12083@atomide.com>
Date: Thu, 15 Mar 2012 17:51:08 +0100
Message-ID: <CACRpkdY9Hi84KOESr1R94PNpvAPn7aMKE4kUcG-O6FMaX84qAA@mail.gmail.com>
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:26 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [120309 10:17]:
>> The core pin controller bindings define:
>> * The fact that pin controllers expose pin configurations as nodes in
>>   device tree.
>> * That the bindings for those pin configuration nodes is defined by the
>>   individual pin controller drivers.
>> * A standardized set of properties for client devices to define numbered
>>   or named pin configuration states, each referring to some number of the
>>   afore-mentioned pin configuration nodes.
>> * That the bindings for the client devices determines the set of numbered
>>   or named states that must exist.
>>
>> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
>
> Great, looks good to me:
>
> Acked-by: Tony Lindgren <tony@atomide.com>

Hm, both you guys agree, then I will be happy that we merge this.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Since it's just toching DT dirs I guess it should go through Grant,
but I'm happy to take it in pinctrl too.

Yours,
Linus Walleij
