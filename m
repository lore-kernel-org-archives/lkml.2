Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2KZTXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:23:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49355 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab2KZTW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:22:59 -0500
MIME-Version: 1.0
In-Reply-To: <1353601899-14648-1-git-send-email-lee.jones@linaro.org>
References: <1353601899-14648-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 26 Nov 2012 20:22:57 +0100
Message-ID: <CACRpkdY-17EkPAsQOkLwLyc7wQRT7FJsY=3nycCe+n+fbMMv0Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Rename dbx500 cpufreq code to be more generic
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 5:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The cpufreq driver doesn't only handle the db8500 anymore. There
> are new variants which rely on it too, so we've renamed the
> driver to be more generic.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Good!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
