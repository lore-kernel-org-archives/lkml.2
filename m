Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab2DCVGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:06:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41039 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2DCVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <4F79C6F7.4070701@wwwdotorg.org>
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
	<1332265479-1260-6-git-send-email-swarren@wwwdotorg.org>
	<CACRpkdav8x-Td-fH1Ree83GhNR8r7aA1dBsTQo2eU3nwwam21Q@mail.gmail.com>
	<4F79C6F7.4070701@wwwdotorg.org>
Date: Tue, 3 Apr 2012 23:06:01 +0200
Message-ID: <CACRpkdbfNPAay=FP_Wj-AmYJBbhcjND9Z-b+mahRM5uQoL-coA@mail.gmail.com>
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

On Mon, Apr 2, 2012 at 5:34 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/01/2012 11:29 AM, Linus Walleij wrote:
>> On Tue, Mar 20, 2012 at 6:44 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>
>>> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
>>> complete specification of the desired pinmux configuration using device
>>> tree.
>>>
>>> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
>>> ---
>>> v2: Rebase on of_property_for_each_string() API changes.
>>
>> Stephen is this eligible for merge? Or does it need changes on top
>> of the v4 core patch?
>
> I believe if you take everything from v3, except replace the one patch
> that I posted a v4 for, and you'll be set. I don't believe the v4
> changes in the intermediate patch required and changes to any later
> patches. Let me know if you want me to repost the series, thanks!

Hm. I went in and applied Viresh's group enumeration refactoring
patch so I suspect tehy need some rebasing. Care to rebase to
the branch in -next tomorrow or so and I'll apply?

Yours,
Linus Walleij
