Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2ITNJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:09:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55016 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2ITNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:09:45 -0400
MIME-Version: 1.0
In-Reply-To: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348138235-3625-1-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 20 Sep 2012 15:09:44 +0200
Message-ID: <CACRpkdYsyuBzxCwkuNmCbdx6_kWNZ7rX1=x3+xaoFq8f2gyFPw@mail.gmail.com>
Subject: Re: [PATCH] pwm-backlight: Take over maintenance
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Matthew Garrett <mjg@redhat.com>, Robert Morell <rmorell@nvidia.com>,
        Dilan Lee <dilee@nvidia.com>, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 12:50 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> Since the pwm-backlight driver is lacking a proper maintainer and is the
> heaviest user of the PWM framework I'm taking over maintenance.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Arun Murthy <arun.murthy@stericsson.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Robert Morell <rmorell@nvidia.com>
> Cc: Dilan Lee <dilee@nvidia.com>
> Cc: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

I love active maintainers:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
