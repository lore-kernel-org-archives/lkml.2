Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AGOKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:10:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1AGOJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:09:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCHv1 02/12] unicore32 core architecture: generic headers stuff
Date: Fri, 7 Jan 2011 00:55:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <00c801cba463$b0f3db00$12db9100$@mprc.pku.edu.cn>
In-Reply-To: <00c801cba463$b0f3db00$12db9100$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070055.53996.arnd@arndb.de>
X-Provags-ID: V02:K0:nsXkHwet8Q+VH4ZapbXI8txw1fgee4XofYUaKgV7Mro
 K85O+SOLIF9vxouptsxGq4MKd+UYF4YbjR1kZZB8fWHM+x7IUS
 SUluB59XfPjl/O+oMpIXeWkTmOwL+/kvkoWjfGqzYMZYJy7mC/
 qzUfkdAeOxxDfWpjr7vxtUIhu1a0tiSWADXJiWZfTcGEO3Bimu
 NaTXmCfwGeIk5WXUhJZXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 December 2010, Guan Xuetao wrote:
> diff --git a/arch/unicore32/include/asm/sizes.h b/arch/unicore32/include/asm/sizes.h
> new file mode 100644
> index 0000000..3720307
> --- /dev/null
> +++ b/arch/unicore32/include/asm/sizes.h
> @@ -0,0 +1,47 @@
> +/*
> + * linux/arch/unicore32/include/asm/sizes.h
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + *
> + * Copyright (C) 2001-2010 GUAN Xue-tao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __UNICORE_SIZES_H__
> +#define __UNICORE_SIZES_H__
> +
> +/* handy sizes */
> +#define SZ_16				0x00000010
> +#define SZ_256				0x00000100
> +#define SZ_512				0x00000200
> ...

This would be nice to have in include/asm-generic. Please make a patch that
adds the file there and use it with your scripts.

> --- /dev/null
> +++ b/arch/unicore32/include/asm/stat.h
> @@ -0,0 +1,71 @@
> +/*
> + * linux/arch/unicore32/include/asm/stat.h

I think we discussed this particular header before. There should be no reason
to have your own version instead of using the generic file like you do for the
rest of the API headers.

	Arnd

