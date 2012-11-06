Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2KFHLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:11:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49751 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2KFHLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:11:44 -0500
MIME-Version: 1.0
In-Reply-To: <1352156701-4038-69-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	<1352156701-4038-69-git-send-email-keescook@chromium.org>
Date: Tue, 6 Nov 2012 15:11:43 +0800
Message-ID: <CAN1soZx2_rqxoGXN564Fam9QF7iruCGmj_zdJVDnB1K26++U3Q@mail.gmail.com>
Subject: Re: [PATCH 068/104] drivers/pcmcia: remove depends on CONFIG_EXPERIMENTAL
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 7:04 AM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Russell King <rmk+kernel@arm.linux.org.uk>
> CC: Manuel Lauss <manuel.lauss@googlemail.com>
> CC: Dominik Brodowski <linux@dominikbrodowski.net>
> CC: Ralf Baechle <ralf@linux-mips.org>
> CC: Haojian Zhuang <haojian.zhuang@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/pcmcia/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index 8fd255f..b90f85b 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -36,8 +36,8 @@ config PCMCIA
>            If unsure, say Y.
>
>  config PCMCIA_LOAD_CIS
> -       bool "Load CIS updates from userspace (EXPERIMENTAL)"
> -       depends on PCMCIA && EXPERIMENTAL
> +       bool "Load CIS updates from userspace"
> +       depends on PCMCIA
>         select FW_LOADER
>         default y
>         help
> --
> 1.7.9.5
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
