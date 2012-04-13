Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2DMMmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:42:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34504 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2DMMmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:42:47 -0400
MIME-Version: 1.0
In-Reply-To: <1334184346-16377-1-git-send-email-swarren@wwwdotorg.org>
References: <1334184346-16377-1-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 13 Apr 2012 14:42:47 +0200
Message-ID: <CACRpkdbgeW4TMg-DiywjQ1YNz5+CtGB+38se9idoVn-eS1OSig@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: ifdef CONFIG_DEBUG_FS cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Only provide prototypes for pin{mux,conf}.c debugfs-related functions
> when both CONFIG_PIN* /and/ CONFIG_DEBUG_FS are enabled, otherwise
> provide static inlines.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Applied.

Thanks,
Linus Walleij
