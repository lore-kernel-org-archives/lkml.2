Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2FQIxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 04:53:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62954 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2FQIxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 04:53:48 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.103.112]
In-Reply-To: <1339435788-16283-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1339435788-16283-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 17 Jun 2012 11:53:27 +0300
Message-ID: <CAK=WgbboTiyjn5W9zr4TE0xk9_YHDmcGzxnMVovs8P=c607r2w@mail.gmail.com>
Subject: Re: [PATCHv2 0/5] remoteproc: Custom firmware handling.
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Jun 11, 2012 at 8:29 PM,  <sjur.brandeland@stericsson.com> wrote:
> Here is a new patch series. I dropped the two bug-fix patches
> since last time, as you already included these. I've tried to
> address all of your review comments since last time, hope I
> didn't miss any.

Thanks, this looks good.

I have a few small mostly-style comments, but I could just do them
while I apply the patches.

I've tried applying the (first four) patches, but since they are still
based on the two bug-fixes patches, they don't apply.

So we can either wait until the bug fixes are merged by Linus (I'm
going to send them soon) or you can rebase the patches on a current
mainline tree (which I could then push to linux-next) - however you
prefer.

> Status:
> I have done a simple simulated test now with the STE firmware
> loader and main-flow seems ok, but I haven't done any negative
> tests.

Ok, thanks. The first four patches seem trivial enough for me to merge
even without any extensive testing.

> - The latest patch is a bit odd. The ste_modem_remoteproc module
>  contains only the firmware handler, and nothing else.

What are your plans regarding the rest of that module? we may want to
wait with the fifth patch until we have some basic functionality.

Thanks,
Ohad.
