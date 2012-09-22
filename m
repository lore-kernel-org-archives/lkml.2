Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2IVLi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:38:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59456 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2IVLi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:38:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbZbuf6PYkT4vcpP4VAejT8mN4CO3PFB9Ng-74Q=4iKTrQ@mail.gmail.com>
References: <1348158776-23858-1-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=WgbZbuf6PYkT4vcpP4VAejT8mN4CO3PFB9Ng-74Q=4iKTrQ@mail.gmail.com>
Date: Sat, 22 Sep 2012 13:38:54 +0200
Message-ID: <CAJK669YswMUghd6nMA+nnuWsMZps4zNoLP0-6fD29Pa3+CzX-g@mail.gmail.com>
Subject: Re: [PATCHv4] remoteproc: Add STE modem driver for remoteproc
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> Thanks, it looks good.
>
> It might be safer though to invoke ->setup() in probe/remove, instead
> of in start/stop (just like you essentially did before).
>
> This way we don't assume that stop is always called before remove (as
> assumption that might be implicitly valid today, but may break in the
> future).
>
> If you want, I can just change that before applying.

Sounds good, please just go ahead and change this before applying.
Thank you.

Regards,
Sjur
