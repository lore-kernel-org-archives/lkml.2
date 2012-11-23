Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2KWM70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:59:26 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60454 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2KWM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:59:24 -0500
MIME-Version: 1.0
In-Reply-To: <1353675386-6749-1-git-send-email-lee.jones@linaro.org>
References: <1353675386-6749-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 23 Nov 2012 18:29:24 +0530
Message-ID: <CAKohponsfpvYgcuJugfYLf6uADGcbqjUAG_Yce2wmn=n_SoCkw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: Simplify IRQ domain registration code in STMPE
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 18:26, Lee Jones <lee.jones@linaro.org> wrote:
> Historically, a driver would have to decide whether it required
> a Linear or Legacy IRQ domain when registering one. This can end
> up as quite a lot of code. A new Simple call now exists which
> simplifies this process. Let's make use of it here.
>
> Samuel Ortiz <sameo@linux.intel.com>

Cc: ?

> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
