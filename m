Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab2CMLvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 07:51:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57554 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2CMLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 07:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1331572380-1064-5-git-send-email-martyn.welch@ge.com>
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>
	<1331572380-1064-5-git-send-email-martyn.welch@ge.com>
Date: Tue, 13 Mar 2012 12:51:51 +0100
Message-ID: <CACRpkdZv84PKts4jFscsNcOq6rggZXSYzu3CBe8NFDTPwsd1aw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] powerpc: Board support for GE IMP3A
From: Linus Walleij <linus.walleij@linaro.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 6:13 PM, Martyn Welch <martyn.welch@ge.com> wrote:

> Initial board support for the GE IMP3A, a 3U compactPCI card with a p2020
> processor.
(...)
> +++ b/arch/powerpc/configs/ge_imp3a_defconfig
> @@ -0,0 +1,257 @@
> +CONFIG_PPC_85xx=y
> +CONFIG_SMP=y
> +CONFIG_NR_CPUS=2
> +CONFIG_EXPERIMENTAL=y
> +CONFIG_SYSVIPC=y
> +CONFIG_POSIX_MQUEUE=y
> +CONFIG_BSD_PROCESS_ACCT=y
> +CONFIG_BSD_PROCESS_ACCT_V3=y
> +CONFIG_SPARSE_IRQ=y

This habit of changing a lot of defconfig stuff in a patch dealing with other
stuff is alien in the ARM world. Especially when changing a horde of stuff
that has nothing to do with the patch subject.

But I don't really know how PPC does these things so who am I to
speak ...

BTW: doesn't the "make saveconfig" reduce defconfigs on PPC?
Paging Uwe on this.

Yours,
Linus Walleij
