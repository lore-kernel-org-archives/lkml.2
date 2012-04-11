Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2DKI31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:29:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34480 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2DKI3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:29:25 -0400
MIME-Version: 1.0
In-Reply-To: <1333511636-9987-1-git-send-email-swarren@wwwdotorg.org>
References: <1333511636-9987-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 11 Apr 2012 10:29:23 +0200
Message-ID: <CACRpkdYAzoiXvTQQCivNnsvmMu_93jWs1rnAqb4R7XGhboWUPA@mail.gmail.com>
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

OK applied this instead of the Kconfig way of fixing things...

Thanks,
Linus Walleij
