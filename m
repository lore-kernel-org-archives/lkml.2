Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2EAW41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:56:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64004 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2EAW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120501153441.5e101139fb096ef262ff1d2b@canb.auug.org.au>
References: <20120501153441.5e101139fb096ef262ff1d2b@canb.auug.org.au>
Date: Wed, 2 May 2012 00:56:24 +0200
Message-ID: <CACRpkdadH_Ju=Nvpem=1nvMBROwjS-ipJcmKTnU9-Hz8SAOBkw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mfd tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?B?IlV3ZSBLbGVpbmUtS/ZuaWci?= 
	<u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 7:34 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/mfd/ab5500-core.c between commit 9ea969f0d79d ("mfd: Mark const
> init data with __initconst instead of __initdata for ab5500") from the
> mfd tree and commit f76facc2354b ("mfd/ab5500: delete AB5500 support")
> from the arm-soc tree.
>
> The latter removes the file, so I did that.

That's correct, thanks!

Linus Walleij
