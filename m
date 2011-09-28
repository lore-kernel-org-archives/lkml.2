Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1I1OJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:09:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1I1OJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 20/24] C6X: library code
Date: Wed, 28 Sep 2011 16:09:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-21-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-21-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281609.41468.arnd@arndb.de>
X-Provags-ID: V02:K0:mP1mBfTYONGa7+wlHIYm8604YIJN7RrwZQDVN1K5xAL
 o7hmQCQQXJPzumpSHpOvp7Yceb0Yj08J/up4WTuNxDHm+zt9o7
 4JRY8ZjJFD6G4OwX0SLjK8rxGhVKQlP+lShLEPnES430Lqrh22
 pL67KB4UpsObWrmCWl7wMLzVWNRt+H6w7acB2VLTKpBEo43Xun
 I9Yo2ZDxyQJntKvf+ZpAPA4oUl1erJXf6hsaAMOmVaG/q8GRwY
 4T5b+t7t95JVt99OUM0ocjhp1Tox0+fWghMawPkrhkKNXown1b
 85NJJFLPY/5Sca7SzMyrV802oBiE3uD1Nz2mcB6PHZkvczksYR
 6YA/KwYaGWZR/jSU/mxc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> +++ b/arch/c6x/include/asm/checksum.h
> @@ -0,0 +1,115 @@
> +/*
> + *  Port on Texas Instruments TMS320C6x architecture
> + *
> + *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
> + *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + */
> +#ifndef _ASM_C6X_CHECKSUM_H
> +#define _ASM_C6X_CHECKSUM_H
> +
> +#include <asm/byteorder.h>

I think you should fall back on the generic checksum.h file and only
provide the declarations that are different. This file is largely
identical to the generic version.

	Arnd
