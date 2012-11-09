Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2KIKK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:10:56 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48122 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2KIKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:10:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121109133111.1070c1062889461152713978@canb.auug.org.au>
References: <20121109133111.1070c1062889461152713978@canb.auug.org.au>
Date: Fri, 9 Nov 2012 11:10:53 +0100
Message-ID: <CACRpkdavH0hOWtC=T5iKLQ-BJ6h5CzROcYkZ7=nhHSR4hT6hpQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 3:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/pinctrl/pinctrl-nomadik.c between commit 241e51ebd3b2
> ("pinctrl/nomadik: make independent of prcmu driver") from the pinctrl
> tree and commit 44e47ccf8ab6 ("Merge branch 'next/multiplatform' into
> for-next") from the arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This looks like the correct fix, thanks a lot Stephen!

Yours,
Linus Walleij
