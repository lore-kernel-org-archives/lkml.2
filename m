Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966645Ab2EPJgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:36:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46841 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966066Ab2EPJgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120516185045.2f9e9274f373d584fd499eb2@canb.auug.org.au>
References: <20120516185045.2f9e9274f373d584fd499eb2@canb.auug.org.au>
Date: Wed, 16 May 2012 17:36:30 +0800
Message-ID: <CAN1soZzBZUoCR5KgXbWBKAnxaR92CKFWqNMNLnm-dAD3xoH6yw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 4:50 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/Kconfig between commit 98fab064d321 ("ARM: Remove unnecessary
> selection of TICK_ONESHOT") from the arm tree and commit c24b31147a06
> ("ARM: mmp: support DT in irq") from the arm-soc tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/Kconfig
> index b1a717c,852b12b..0000000
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@@ -627,6 -616,8 +611,7 @@@ config ARCH_MM
>        select CLKDEV_LOOKUP
>        select GENERIC_CLOCKEVENTS
>        select GPIO_PXA
> +       select IRQ_DOMAIN
>  -      select TICK_ONESHOT
>        select PLAT_PXA
>        select SPARSE_IRQ
>        select GENERIC_ALLOCATOR

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
