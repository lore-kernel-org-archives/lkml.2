Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2FQR0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:26:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63690 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab2FQR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:26:07 -0400
MIME-Version: 1.0
In-Reply-To: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
References: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
Date: Sun, 17 Jun 2012 19:26:05 +0200
Message-ID: <CACRpkda6FJm4fiQ9w0Mo80_B7W09yCwMdMeqoiDUtkifJ88_RQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: mxs: Use kfree to fix build error
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@freescale.com, devendra.aaru@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 7:06 PM, Fabio Estevam
<fabio.estevam@freescale.com> wrote:

> commit 0bf7481 (pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails)
> introduced the following build error:
>
> drivers/pinctrl/pinctrl-mxs.c:140:3: error: implicit declaration of function 'free'
>
> Use kfree function instead.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied, hm, Devendra please compile-test your patches ;-)

thanks,
Linus Walleij
