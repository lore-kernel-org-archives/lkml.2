Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab2FQL5e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 07:57:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51965 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab2FQL5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 07:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbboTiyjn5W9zr4TE0xk9_YHDmcGzxnMVovs8P=c607r2w@mail.gmail.com>
References: <1339435788-16283-1-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=WgbboTiyjn5W9zr4TE0xk9_YHDmcGzxnMVovs8P=c607r2w@mail.gmail.com>
Date: Sun, 17 Jun 2012 13:57:31 +0200
X-Google-Sender-Auth: fLOMdjUd_1aoqljA1gur-x_vivg
Message-ID: <CAJK669bmXFZT=9VBx1gt6jxpFdO6Z8zrLmfE0t6gp6n=H=GyNw@mail.gmail.com>
Subject: Re: [PATCHv2 0/5] remoteproc: Custom firmware handling.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> I have a few small mostly-style comments, but I could just do them
> while I apply the patches.

Yes, please feel free to fix things when needed.

> I've tried applying the (first four) patches, but since they are still
> based on the two bug-fixes patches, they don't apply.
>
> So we can either wait until the bug fixes are merged by Linus (I'm
> going to send them soon) or you can rebase the patches on a current
> mainline tree (which I could then push to linux-next) - however you
> prefer.

Either way works for me. I'm not in particular rush to get things in, but
I'll send you a rebased version tomorrow anyway.

>> - The latest patch is a bit odd. The ste_modem_remoteproc module
>>  contains only the firmware handler, and nothing else.
>
> What are your plans regarding the rest of that module? we may want to
> wait with the fifth patch until we have some basic functionality.

I am brewing a module and I hope to send it out for review
as RFC within a week or two. It will probably make most sense to
merge the module as a whole and not just the firmware handler.
So I suggest we wait with the firmware handler until you have reviewed the
patches on the ste-modem-rproc and we can take it from there.

Regards,
Sjur
