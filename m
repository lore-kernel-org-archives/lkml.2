Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2GEABk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:01:40 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48657 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab2GEABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <1341378617-10386-19-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	<1341378617-10386-19-git-send-email-bryan.wu@canonical.com>
Date: Thu, 5 Jul 2012 02:01:38 +0200
Message-ID: <CACRpkdb3HtgSZwV-ivU6gU+DSBXZoiBVDi1LPnDkZ0LWQ+ZY6A@mail.gmail.com>
Subject: Re: [PATCH 18/25] leds: convert LM3530 LED driver to devm_kzalloc()
 and cleanup error exit path
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 7:10 AM, Bryan Wu <bryan.wu@canonical.com> wrote:

> Cc: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/leds-lm3530.c |   24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)

This is good stuff,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

But make sure to send the patch by Andrew for it to be merged.

Yours,
Linus Walleij
