Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1LLMwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:52:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42020 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1LLMwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:52:44 -0500
MIME-Version: 1.0
In-Reply-To: <1323475145-26430-3-git-send-email-swarren@nvidia.com>
References: <1323475145-26430-1-git-send-email-swarren@nvidia.com>
	<1323475145-26430-3-git-send-email-swarren@nvidia.com>
Date: Mon, 12 Dec 2011 13:52:43 +0100
Message-ID: <CACRpkdYSvgh9sY1WnWURh-O3u=d+Uu8X+GiAprJaVbEcTA2i7Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: Don't create a device for each pin controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 12:59 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Pin controllers should already be instantiated as a device, so there's
> no need for the pinctrl core to create a new struct device for each
> controller.
>
> This allows the controller's real name to be used in the mux mapping
> table, rather than e.g. "pinctrl.0", "pinctrl.1", etc.

Hey cool, this "just works" on U300!

And it is what we want for future device tree work I highly suspect.

I'll push the change to linux-next!

Thanks,
Linus Walleij
