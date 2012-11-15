Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993405Ab2KOLcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:32:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40739 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:32:24 -0500
MIME-Version: 1.0
In-Reply-To: <1352809250.4819.1.camel@phoenix>
References: <1352809250.4819.1.camel@phoenix>
Date: Thu, 15 Nov 2012 12:32:22 +0100
Message-ID: <CACRpkdbfxFsz8KokTmj-j3cbWpPrJr8c6MmZgU0rMBriOMMJ-g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: spear: Make get_gpio_pingroup return NULL when
 no gpio_pingroup found
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 1:20 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Currently get_gpio_pingroup() may return NULL or ERR_PTR(-EINVAL) when
> no gpio_pingroup found. The caller in gpio_request_endisable() only
> checks if the return value is NULL. Return ERR_PTR(-EINVAL) for
> get_gpio_pingroup() causes problem and seems not necessary.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Viresh's ACK.

Yours,
Linus Walleij
