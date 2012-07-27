Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2G0XLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:11:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42659 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2G0XLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <1342859878-12631-1-git-send-email-develkernel412222@gmail.com>
References: <1342859878-12631-1-git-send-email-develkernel412222@gmail.com>
Date: Sat, 28 Jul 2012 01:11:23 +0200
Message-ID: <CACRpkdZoNDNLfmGNODCUPedC3O57xCg+mKVDGNQzitk15Hv6cA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/pinctrl-u300: remove unneeded devm_kfree call
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 10:37 AM, Devendra Naga
<develkernel412222@gmail.com> wrote:

> the allocated memory will be destroyed at the driver unload time,
> automatically if driver uses the devm_ functions, so no need of
> doing devm_kfree at the error path
>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>

Applied.

Thanks!
Linus Walleij
