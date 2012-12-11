Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2LKJRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:17:16 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64209 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKJRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:17:14 -0500
MIME-Version: 1.0
In-Reply-To: <1355129761-8088-7-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-7-git-send-email-lee.jones@linaro.org>
Date: Tue, 11 Dec 2012 10:17:13 +0100
Message-ID: <CACRpkdZJFbHSwowKnfWyXLckVePHrC6o2CtDJaFb+dXTkNYPjw@mail.gmail.com>
Subject: Re: [PATCH 06/12] ARM: ux500: Set correct MMCI regulator voltages in
 the ux5x0 Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 9:55 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The voltages for the MMCI GPIO controlled voltage regulation differ
> depending on who you believe and where you pick the information up
> from. More recent internal code suggests that the true upper voltage
> from the shifter is actually v3.3, instead of the previously
> indicated v2.9. Let's mirror that change in the Device Tree file.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
