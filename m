Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2FRGHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:07:33 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54726 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2FRGHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <1339868737-5945-1-git-send-email-devendra.aaru@gmail.com>
References: <1339868737-5945-1-git-send-email-devendra.aaru@gmail.com>
Date: Mon, 18 Jun 2012 08:07:31 +0200
Message-ID: <CACRpkdZNfb8ed=1bWDq9rdZwE5rydN_1Lg+Nt4tiQNhruCAiWA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/pinctrl-u300: remove devm_kfree at driver unload
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 7:45 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> the memory allocated by devm_kzalloc is automatically
> freed at the driver detach side, so no neeed of calling
> devm_kfree
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied, thanks!
Linus Walleij
