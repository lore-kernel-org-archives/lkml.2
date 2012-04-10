Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2DJIxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:53:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51708 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2DJIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <1333511636-9987-1-git-send-email-swarren@wwwdotorg.org>
References: <1333511636-9987-1-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:53:34 +0200
Message-ID: <CACRpkdbceDUOj4GoAH6FXpMQt6QQopRQsXbfKW9PDTkgk+gZkQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: fix build when CONFIG_OF && !CONFIG_PINCTRL
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:53 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> pinctrl/devicetree.c won't compile when !CONFIG_PINCTRL, since the
> pinctrl headers don't declare some types when !PINCTRL. Make sure
> pinctrl/Makefile only attempts to compile devicetree.c when OF &&
> PINCTRL.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

I fixed this other Kconfig patch to address the same problem.

If you think this approach is better let me know...

Yours,
Linus Walleij
