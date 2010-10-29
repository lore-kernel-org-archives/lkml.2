Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368Ab0J2LRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:17:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36140 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759688Ab0J2LRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vG05yMArbSL11X/copk6h3e9o3YAVDrnkEv3UElMmURDkRxUaPGR7hr/ZBMxfJKiWf
         LthGFuz1pLx+qoE5yyir7tpazc+r2qDwnVCSS5Z7BHqbppwXKH4heR2QS9xS5slt2Chv
         pmovqrDgQtkHCF99KmLrt6YJ8oUTk5rGCZEDE=
MIME-Version: 1.0
In-Reply-To: <181be0f834f3670249d3c8d7ba1462dab1ece2c1.1288321597.git.mirq-linux@rere.qmqm.pl>
References: <cover.1288321597.git.mirq-linux@rere.qmqm.pl>
	<181be0f834f3670249d3c8d7ba1462dab1ece2c1.1288321597.git.mirq-linux@rere.qmqm.pl>
Date: Fri, 29 Oct 2010 14:17:07 +0300
Message-ID: <AANLkTik+r8r-pywpFYfwrZX2bTjgAVd1rwvoTi7ttq3B@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Gemini: create platform device for ethernet in
 Raidsonic IB-4220B
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Janos Laube <janos.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/29 Michał Mirosław <mirq-linux@rere.qmqm.pl>:
> This is cherry-picked from:
>
> git://git.berlios.de/gemini-board ib4220
>
> Code by Paulius Zaleckas <paulius.zaleckas@gmail.com>
> and Janos Laube <janos.dev@gmail.com>.
>
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
>
>  arch/arm/mach-gemini/board-nas4220b.c    |   53 ++++++++++++++++++++++++++++++
>  arch/arm/mach-gemini/common.h            |    2 +
>  arch/arm/mach-gemini/devices.c           |   52 +++++++++++++++++++++++++++++
>  arch/arm/mach-gemini/include/mach/gmac.h |   21 ++++++++++++
>  4 files changed, 128 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-gemini/include/mach/gmac.h
>
[...]
> diff --git a/arch/arm/mach-gemini/include/mach/gmac.h b/arch/arm/mach-gemini/include/mach/gmac.h
> new file mode 100644
> index 0000000..c6eeacc
> --- /dev/null
> +++ b/arch/arm/mach-gemini/include/mach/gmac.h
> @@ -0,0 +1,21 @@
> +/*
> + * Gemini GMAC specific defines
> + *
> + * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>

This e-mail is dead. Please change it to gmail one.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef __MACH_GMAC_H__
> +#define __MACH_GMAC_H__
> +
> +#include <linux/phy.h>
> +
> +struct gemini_gmac_platform_data {
> +       char *bus_id[2]; /* NULL means that this port is not used */
> +       phy_interface_t interface[2];
> +};
> +
> +#endif /* __MACH_GMAC_H__ */
> --
> 1.7.1
>
>
