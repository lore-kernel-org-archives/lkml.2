Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2ITHEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:04:45 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38452 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2ITHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120920160314.b3ea668fc0766224c24bf276@canb.auug.org.au>
References: <20120920160314.b3ea668fc0766224c24bf276@canb.auug.org.au>
Date: Thu, 20 Sep 2012 09:04:42 +0200
Message-ID: <CACRpkdaLr-v2CBjZsqLGx_tmthJYLscnEQhhDQrqTAQ0TVW87g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 8:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-integrator/integrator_cp.c between commit 73efd53012af
> ("ARM: 7519/1: integrator: convert platform devices to Device Tree") from
> the arm tree and commit b7a3f8db07c1 ("ARM: integrator: use __iomem
> pointers for MMIO") from the arm-soc tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks correct!
Thanks.
Linus Walleij
