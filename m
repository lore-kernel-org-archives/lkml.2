Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1H3HR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:17:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63115 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1H3HR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:17:58 -0400
Message-ID: <4E5C8EA3.7060304@gmail.com>
Date: Tue, 30 Aug 2011 09:17:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vishnupradeep <intermedia.vishnu@gmail.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: linux-3.0.4 compile error on file arch/x86/include/asm/unistd_64.h
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
In-Reply-To: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 08:07 AM, Vishnupradeep wrote:
> CC      net/ipv4/ip_forward.o
> CC      net/ipv4/ip_options.o
> CC      net/ipv4/ip_output.o
> CC      net/ipv4/ip_sockglue.o
> In file included from
> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/unistd.h:5:0,
>                  from include/linux/unistd.h:7,
>                  from
> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/seccomp_64.h:4,
>                  from
> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/seccomp.h:4,
>                  from include/linux/seccomp.h:8,
>                  from include/linux/sched.h:80,
>                  from
> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/compat.h:8,
>                  from include/linux/compat.h:18,
>                  from include/linux/ethtool.h:17,
>                  from include/linux/netdevice.h:48,
>                  from include/linux/inetdevice.h:8,
>                  from net/ipv4/ip_sockglue.c:24:
> /media/Portable/linux-kernel/linux-3.0.4/arch/x86/include/asm/unistd_64.h:668:2:
> error: invalid preprocessing directive #Define

There is nothing like "#Define" here. Are you sure you didn't modify the
file?

-- 
js
