Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2CLVmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:42:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59582 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2CLVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:42:49 -0400
MIME-Version: 1.0
In-Reply-To: <4F5E3F63.5080506@wwwdotorg.org>
References: <1330993336-9538-1-git-send-email-swarren@nvidia.com>
	<1330993336-9538-2-git-send-email-swarren@nvidia.com>
	<CACRpkdYdSaNsrr34o2Cc4vS12ee9oY7FG0pxB92mefHZKwdEpA@mail.gmail.com>
	<4F5E3F63.5080506@wwwdotorg.org>
Date: Mon, 12 Mar 2012 22:42:48 +0100
Message-ID: <CACRpkdYsD2LCNoox6ztHTP76X8a_qxjiZFO4ou=BgZ4oE0qHtg@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] pinctrl: allow concurrent gpio and mux function
 ownership of pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 7:24 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Linus, now that Grant has ack'd and applied the documentation change
> behind this, could you take this one patch into the pinctrl tree.

Of course, applied.

> I assume it's 3.5 material.

No it goes in now, we can't have documentation that is misleading...
Besides, I like it.

Yours,
Linus Walleij
