Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab0GQLbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 07:31:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60748 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759841Ab0GQLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 07:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YNCxDn1ueIKcxbCc8Dib32et1LXSu97hTFHPwZRpeYi06VIurFOE2bR2Ze8bZA2k9G
         un7/6bRw+uGESL5BcDbwJwGfp+OAQkNcOYf60LADZ7dZikA8NVMwCaJA1HhaPFN17Qel
         oo3z26Bk4wZxPP1vbs2tHNb+k/UGRJA0s/nUs=
MIME-Version: 1.0
In-Reply-To: <1279365780-18462-1-git-send-email-triad@df.lth.se>
References: <1279365780-18462-1-git-send-email-triad@df.lth.se>
Date: Sat, 17 Jul 2010 13:31:48 +0200
Message-ID: <AANLkTinDXAG9SzS1WFSyMvMAKTlYaVI362hDaravQYlQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] MISC: driver for the character LCD found in ARM 
	refdesigns
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/17 Linus Walleij <triad@df.lth.se>:

> This adds a driver for the character LCD found on the ARM Versatile
> and RealView Platform Baseboards. It doesn't do very much more than
> display the text "ARM Linux" on the first line and the linux banner
> on the second line, but that's still useful.

Some rebasing lost the commit comments after the patch...

We discussed the placement of this driver on the ARM Linux kernel
mailing list, originally it was in arch/arm/common, with arch/arm/plat-versatile
recommended if it should stay in the arch/arm tree.

However the overpopulation in arch/arm lead us to try and push it
into drivers/.

Other alternatives to drivers/misc:

- Create drivers/platform/arm and put it there
- Create drivers/lcd and hope for more LCD drivers
- Keep it in arch/arm/plat-versatile/

Andrew, since you seem to keep an eye on drivers/misc, is it OK
to merge this through Russells tree if the placement here is agreed
upon?

Yours,
Linus Walleij
