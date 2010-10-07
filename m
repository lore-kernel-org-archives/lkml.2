Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0JGWtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:49:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20354 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0JGWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:49:48 -0400
Date: Fri, 08 Oct 2010 07:50:03 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH v3 2/2] MAINTAINERS: Add Samsung S5P series FIMC maintainers
In-reply-to: <20100929090904.GA21199@july>
To: "'Kyungmin Park'" <kmpark@infradead.org>, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        rmk@arm.linux.org.uk, m.szyprowski@samsung.com, pawel@osciak.com,
        t.fujak@samsung.com, s.nawrocki@samsung.com
Message-id: <00bf01cb6671$fd8d8900$f8a89b00$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActftfvlZMDAQCb6Rj6mtrn+TLQlKwGungsQ
References: <20100929090904.GA21199@july>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Add Samsung S5P series FIMC(Camera Interface) maintainers
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v2:
> 	Write the right maintainers
> 
>  MAINTAINERS |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8ae1797..1e233d9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -977,6 +977,16 @@ L:	linux-arm-kernel@lists.infradead.org
>  S:	Maintained
>  F:	arch/arm/mach-s5pv310/mach-universal_c210.c
> 
> +ARM/SAMSUNG S5P SERIES FIMC SUPPORT
> +M:	Kyungmin Park <kyungmin.park@samsung.com>
> +M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
> +L:	linux-arm-kernel@lists.infradead.org
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	arch/arm/plat-s5p/dev-fimc*
> +F:	arch/arm/plat-samsung/include/plat/*fimc*

Hi,

If required FIMC support maintainer, please remove above 2 lines...because
the plat-s5p/dev-fimc* are just platform data files and entirely removed
plat-samsung/include/plat/fimc.h header for removing platform code
dependency by Sylwester's FIMC patch.

> +F:	drivers/media/video/s5p-fimc/
> +
>  ARM/SHMOBILE ARM ARCHITECTURE
>  M:	Paul Mundt <lethal@linux-sh.org>
>  M:	Magnus Damm <magnus.damm@gmail.com>
> --


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

