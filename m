Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2JSSLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:11:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37189 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab2JSSLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <1350641777-19605-2-git-send-email-wency@cn.fujitsu.com>
References: <1350641777-19605-1-git-send-email-wency@cn.fujitsu.com> <1350641777-19605-2-git-send-email-wency@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 14:11:31 -0400
X-Google-Sender-Auth: NYL8qhxM8XTMXw13lDrmVIWToH8
Message-ID: <CAHGf_=oDTLC8ebNgwCbT7NyxLre9c8ZokEKgjrORgzaHfZsTqQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 1/2] update mem= option's spec according to its implementation
To: wency@cn.fujitsu.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, bhelgaas@google.com,
        hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com,
        muneda.takahiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 6:16 AM,  <wency@cn.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> Current mem= implementation seems buggy because specification and
> implementation doesn't match. Current mem= has been working
> for many years and it's not buggy, it works as expected. So
> we should update the specification.
>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> Sort-of-tentatively-acked-by: Rob Landley <rob@landley.net>
> ---
>  Documentation/kernel-parameters.txt |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9776f06..85b911a 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1481,9 +1481,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>         mem=nn[KMG]     [KNL,BOOT] Force usage of a specific amount of memory
>                         Amount of memory to be used when the kernel is not able
>                         to see the whole system memory or for test.
> -                       [X86-32] Use together with memmap= to avoid physical
> -                       address space collisions. Without memmap= PCI devices
> -                       could be placed at addresses belonging to unused RAM.
> +                       [X86-32] Work as limiting max address. Use together
> +                       with memmap= to avoid physical address space collisions.
> +                       Without memmap= PCI devices could be placed at addresses
> +                       belonging to unused RAM.

If my remember is correct, x86-64 also specify maximum address.
but my remember is not clear.
