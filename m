Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1I1NyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:54:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63979 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1I1NyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:54:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 17/24] C6X: loadable module support
Date: Wed, 28 Sep 2011 15:54:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-18-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-18-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281554.12001.arnd@arndb.de>
X-Provags-ID: V02:K0:jQ6z/Ydn8IxmeAq7PJUQUepV8S22YgQjIXWyLTtWLD2
 8ME8qkz/Uy2Uy+cCnbWlNaq2JoyN7v8CnqmShPGi8puA11V0oq
 j84LDSQ5PDCS5N1fOlD6w6mECaBMyOm6GswqrK4Ui6x6cM2J8K
 QqXOodUixVdAwqFSjVGGj1Cd452yk5l8K+3uISdjGPP0Q6L82v
 tVLNO47H3bcVy2wCBrat4LrHn9WnAsPANUupXh+K/NeQ9gTXqg
 kosj/Oq5ionPirUwatgC75jHErxhHoAyojeVFhAvEeT8ZoiajU
 F6fa5DfjAUKlCU4YNrppmYz2c3442ovayuToefFLi6B7nfSXg5
 mHvmRr7TYlzU4t7E5IhI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/c6x/include/asm/module.h |   33 +++++++++++
>  arch/c6x/kernel/c6x_ksyms.c   |   68 +++++++++++++++++++++
>  arch/c6x/kernel/module.c      |  129 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 230 insertions(+), 0 deletions(-)
>  create mode 100644 arch/c6x/include/asm/module.h
>  create mode 100644 arch/c6x/kernel/c6x_ksyms.c
>  create mode 100644 arch/c6x/kernel/module.c

Acked-by: Arnd Bergmann <arnd@arndb.de>

> +
> +#ifdef DEBUG
> +#define DBG(fmt...) pr_debug(fmt)
> +#else
> +#define DBG(fmt...)
> +#endif

Note that this is unnecesary. pr_debug is already conditional.

	Arnd
