Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2JBK5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:57:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48928 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2JBK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <1349165603-24401-9-git-send-email-lee.jones@linaro.org>
References: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
	<1349165603-24401-9-git-send-email-lee.jones@linaro.org>
Date: Tue, 2 Oct 2012 12:57:50 +0200
Message-ID: <CACRpkdaM1SxcrAn086W+b-oC+k6w=SEhxq0CGqrA_4iXmgfWYA@mail.gmail.com>
Subject: Re: [PATCH 08/10] ARM: ux500: Stop calling the UIB init function when
 using Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:13 AM, Lee Jones <lee.jones@linaro.org> wrote:

> As there will be a Device Tree created for the UIBs, there is no
> need to call the UIB initiation functions. Each device will be
> detailed and registered from the Device Tree instead.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by, but...

> -       .init_late      = ux500_init_late,
> +       .init_late      = NULL,

Why even define it?

Yours,
Linus Walleij
