Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2FTPkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:40:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48006 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2FTPkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:40:16 -0400
MIME-Version: 1.0
In-Reply-To: <1340181732-21953-1-git-send-email-linus.walleij@stericsson.com>
References: <1340181732-21953-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 20 Jun 2012 21:10:15 +0530
Message-ID: <CADTbHxpyOqwx-VqmW5FGS9Qh2YUtsLRHyqXf7snSwS4JWLjnLQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl/coh901: use clk_prepare_[en|dis]able()
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 2:12 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> The COH901 GPIO driver did not prepare or unprepare its
> clock, so let us fix it to do so.
>
> Cc: Pankaj Jangra <jangra.pankaj9@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Fix up to use clk_disable_unprepare() on error and exit paths,
>  noticed by Pankaj Jangra.
> ---
>  drivers/pinctrl/pinctrl-coh901.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Pankaj Jangra <jangra.pankaj9@gmail.com>

Regards,
Pankaj Jangra
