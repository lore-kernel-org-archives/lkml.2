Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2DZIuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:50:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59016 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2DZIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <1335371536-24072-1-git-send-email-swarren@wwwdotorg.org>
References: <1335371536-24072-1-git-send-email-swarren@wwwdotorg.org>
Date: Thu, 26 Apr 2012 10:49:58 +0200
Message-ID: <CACRpkdZysM6AxaRc3+jEAU=Y85w3BBRyhyj-7J_BwY0W7qcDzw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: propagate map validation errors
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 6:32 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> pinctrl_register_map() was returning early if pinmux_validate_map() or
> pinconf_validate_map() failed, but was not actually returning the error
> code.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Obviously correct so applied.

Thanks,
Linus Walleij
