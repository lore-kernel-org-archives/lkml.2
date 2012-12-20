Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2LTTJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:09:36 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:33834 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2LTTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:09:31 -0500
MIME-Version: 1.0
In-Reply-To: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
References: <1355937587-31730-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 20 Dec 2012 20:09:29 +0100
Message-ID: <CACRpkdZpe_=qRHG9paz0Rv9wNY2zfuG+xChdq+HVWJ4jvdgSfw@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: ux500: Provide a means to obtain the SMSC9115
 clock when DT is enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 6:19 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Device Tree names devices differently to how some frameworks expect
> them. Until we can move a platform over to the new way of obtaining
> resources, we have to use the OF_DEV_AUXDATA() macros to craft a
> device name which can be used in searches during allocation time.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I think that the best way to fix this regression is to gather
ACKs from the involved subsystems and push it throug
ARM SoC directly.

I thing Cc: stable@kernel.org needs to be added to all patches
in this set as well.

Yours,
Linus Walleij
