Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2EPH04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:26:56 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45567 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381Ab2EPH0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:26:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120516151441.59baed915e31738642fd52dd@canb.auug.org.au>
References: <20120516151441.59baed915e31738642fd52dd@canb.auug.org.au>
Date: Wed, 16 May 2012 09:26:53 +0200
Message-ID: <CACRpkdbhyL4eJOLZ0pw_T3LDwPpFJM4BWVAhKh8hZADMJ4PBEA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the crypto tree with the arm tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Andreas Westin <andreas.westin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 7:14 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the crypto tree got a conflict in
> arch/arm/mach-ux500/devices-common.h between commit 08956a0e8a69 ("ARM:
> 7372/1: ux500: factor out dynamic amba device allocator") from the  tree
> and commit 585d188f8072 ("mach-ux500: crypto - core support for CRYP/HASH
> module") from the crypto tree.
>
> Just context changes (maybe).  I fixed it up (see below) and can carry
> the fix as necessary.
>
> I suspect that there may be something deeper here, though.

This looks correct, thanks Stephen!

Linus Walleij
