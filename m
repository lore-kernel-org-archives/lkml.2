Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2GEICK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:02:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57432 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2GEICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <1341452295.5435.1.camel@phoenix>
References: <1341452295.5435.1.camel@phoenix>
Date: Thu, 5 Jul 2012 10:02:07 +0200
Message-ID: <CACRpkdb9UrfKYcLB_4ZpzmPJ54pun27_4H-mCYhH7-kuHVXJfQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab3100: Use rdev_get_drvdata() rather than use
 reg->reg_data driectly
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:38 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab3100.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel!
Linus Walleij
