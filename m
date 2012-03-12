Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2CLTfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:35:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63356 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab2CLTfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <1331197863-25564-1-git-send-email-bryan.wu@canonical.com>
References: <1331197863-25564-1-git-send-email-bryan.wu@canonical.com>
Date: Mon, 12 Mar 2012 20:35:42 +0100
Message-ID: <CACRpkdYA3kjhnaeC2whfTEynJDB+MO=GQXd6TZfSSRGWzTUZEw@mail.gmail.com>
Subject: Re: [PATCH 1/3] led-class: change back LEDS_CLASS to tristate instead
 of bool
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: rpurdie@rpsys.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 10:11 AM, Bryan Wu <bryan.wu@canonical.com> wrote:

> After moving some core functions to led-core.c, led-class.c can be built as
> module again.
>
> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>

Thanks for driving this Bryan,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
