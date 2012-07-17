Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2GQSbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:31:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51144 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab2GQSbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <1342511295-13298-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1342511295-13298-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Jul 2012 20:31:33 +0200
Message-ID: <CACRpkdbWsC1S35Ms2gq-BqOwQaGvGijXnzr4xH4MOViuiZksug@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: arizona: Add WM5110 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 9:48 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/gpio/gpio-arizona.c |    1 +
>  1 file changed, 1 insertion(+)

Patch applied. OK if I squash this into the Arizona driver submission
patch?

Thanks,
Linus Walleij
