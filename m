Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2BASzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:55:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38480 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2BASz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <1328099500-15923-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1328099500-15923-1-git-send-email-xiyou.wangcong@gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 1 Feb 2012 13:55:08 -0500
X-Google-Sender-Auth: e-8ykRPQkIlA4LxiWlgONHTAGWw
Message-ID: <CAMjpGUeBUxazCSo4Lr3ewaFeABszqUCE+N4jYnzt7aPLmx6+3w@mail.gmail.com>
Subject: Re: [V2 Patch] nmi watchdog: do not use cpp symbol in Kconfig
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q11ItZ08020794

On Wed, Feb 1, 2012 at 07:31, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> ARCH_HAS_NMI_WATCHDOG is a macro defined by arch,
> but config HARDLOCKUP_DETECTOR depends on it.
> This is wrong, ARCH_HAS_NMI_WATCHDOG has to be a Kconfig
> config, and arch's need it should select it explicitly.
>
> ---
> Â arch/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  Â 3 +++
> Â arch/blackfin/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  | Â  Â 1 +
> Â arch/blackfin/include/asm/irq.h Â  Â  Â  | Â  Â 4 ----
> Â arch/mn10300/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  Â 1 +
> Â arch/mn10300/include/asm/reset-regs.h | Â  Â 4 ----
> Â arch/sparc/Kconfig Â  Â  Â  Â  Â  Â  Â  Â  Â  Â | Â  Â 1 +
> Â arch/sparc/include/asm/irq_64.h Â  Â  Â  | Â  Â 1 -
> Â include/linux/nmi.h Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â  Â 2 +-
> Â lib/Kconfig.debug Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  | Â  Â 2 +-
> Â 9 files changed, 8 insertions(+), 11 deletions(-)

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
