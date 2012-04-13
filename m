Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2DMMkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:40:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37112 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2DMMkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1334163370-21991-1-git-send-email-swarren@wwwdotorg.org>
References: <1334163370-21991-1-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 13 Apr 2012 14:40:20 +0200
Message-ID: <CACRpkdZgBQtJSOsCrnRxSmPdp=eLanzQYo7dAPiyOu=-+KfHmA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: implement devm_pinctrl_get()/put()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 6:56 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> These functions allow the driver core to automatically clean up any
> allocations made by drivers, thus leading to simplified drivers.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Note: this hasn't been tested beyond a compile-test.

I like the idea. Can you put some blurb in the documentation
as well, so implementers get it right from day 1?

Yours,
Linus Walleij
