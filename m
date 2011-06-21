Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1FUJmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:42:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45242 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab1FUJmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <1307692817-15602-1-git-send-email-linus.walleij@stericsson.com>
References: <1307692817-15602-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 21 Jun 2011 11:42:31 +0200
Message-ID: <BANLkTinhxC1efmiTrB4fC3TqTqzBWhSxgg@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds/lm3530: calibrate ALS input voltage
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, this one:

On Fri, Jun 10, 2011 at 10:00 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
>
> This patch provides the support for auto calibration of ALS Zone
> boundaries based on min/max ALS input voltage.
>
> Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Can you pick this and [2/2] to the -mm tree too unless RIchard is very unhappy
about it? It's pretty straight-forward improvements.

Yours,
Linus Walleij
