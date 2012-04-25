Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2DYLWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:22:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65203 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2DYLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F96D84E.7080204@wwwdotorg.org>
References: <CACRpkdYqZrNFxj4kyMqYZk5PAcjF6-TroJ+Xq+3EVBLvo5Zg-Q@mail.gmail.com>
	<4F96D84E.7080204@wwwdotorg.org>
Date: Wed, 25 Apr 2012 13:22:23 +0200
Message-ID: <CACRpkdZMsvmQ8AV=7aeAOraZJsYh_uyYPwrDrkYcegWOi7WDNA@mail.gmail.com>
Subject: Re: Tag on pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dong Aisheng <B29396@freescale.com>, viresh kumar <viresh.kumar@st.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 6:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Linus, I think this will get into the ARM SoC tree simply by my saying
> in my for-3.5/gpio-pinmux pull request that the branch depends on your
> tag; I don't /think/ you need to explicitly send a pull request there,
> right?

Yes I hope so, let's try this and see if it works, if it doesn't,
we'll notice and fix it up someway.

I'll make sure I send a pull request to Torvalds as early as
possible since the pinctrl tree is pretty independent of any
other stuff.

Thanks,
Linus Walleij
