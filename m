Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993384Ab2KOLGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:06:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49445 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993226Ab2KOLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:06:30 -0500
MIME-Version: 1.0
In-Reply-To: <1352791901.3947.1.camel@phoenix>
References: <1352791901.3947.1.camel@phoenix>
Date: Thu, 15 Nov 2012 12:06:28 +0100
Message-ID: <CACRpkdYgDO-VVUxw8hpuw5kWf4vJnqmBuPcEJ3qaxxpnFSOxZQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: spear: Fix the logic of setting reg in pmx_init_gpio_pingroup_addr
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 8:31 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Current code does not work if count > 1, fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Viresh's ACK, thanks!

Yours,
Linus Walleij
