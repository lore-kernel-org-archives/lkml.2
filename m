Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2DRLRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:17:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48962 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2DRLRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <1334595060-12178-1-git-send-email-swarren@wwwdotorg.org>
References: <1334595060-12178-1-git-send-email-swarren@wwwdotorg.org>
Date: Wed, 18 Apr 2012 13:17:29 +0200
Message-ID: <CACRpkda0AqE4nS4YRMK3Us7dMf3ujy6V8TZB8deV9P6Kgaimmg@mail.gmail.com>
Subject: Re: [PATCH V3] pinctrl: implement devm_pinctrl_get()/put()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 6:51 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> These functions allow the driver core to automatically clean up any
> allocations made by drivers, thus leading to simplified drivers.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v3: Update Documentation/driver-model/devres.txt.
> v2:
> * Updated documentation to describe and recommend using devm_* functions.
> * Added devm_pinctrl_get_select() and devm_pinctrl_get_select_default() to
>  consumer.h

Nobody's complaining anymore and I like it, so applied it!

Yours,
Linus Walleij
