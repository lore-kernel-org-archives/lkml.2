Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab2LAP4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 10:56:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39752 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2LAP4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 10:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <1353675386-6749-1-git-send-email-lee.jones@linaro.org>
References: <1353675386-6749-1-git-send-email-lee.jones@linaro.org>
Date: Sat, 1 Dec 2012 16:56:41 +0100
Message-ID: <CACRpkdbkGD3edGFf=3begHOtoYg+kZFHgQriZ4LT1OEz1FpD=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: Simplify IRQ domain registration code in STMPE
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, viresh.kumar@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 1:56 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Historically, a driver would have to decide whether it required
> a Linear or Legacy IRQ domain when registering one. This can end
> up as quite a lot of code. A new Simple call now exists which
> simplifies this process. Let's make use of it here.
>
> Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Should do the trick!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
