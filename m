Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2GEAAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:00:01 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37881 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2GDX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 19:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <1341367403.10587.3.camel@phoenix>
References: <1341367403.10587.3.camel@phoenix>
Date: Thu, 5 Jul 2012 01:59:58 +0200
Message-ID: <CACRpkdbb1Fh5mTxj8AiB-h8mgRcTj_ZjdMYiHqv=1M9_Kcxuzw@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab3100: Set enable enable_time in regulator_desc
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

On Wed, Jul 4, 2012 at 4:03 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab3100.c |   37 +++++++++----------------------------
>  1 file changed, 9 insertions(+), 28 deletions(-)

Thanks!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
