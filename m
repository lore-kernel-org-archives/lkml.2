Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2ENCYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:24:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54101 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2ENCY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:24:29 -0400
MIME-Version: 1.0
In-Reply-To: <1336661600-2409-1-git-send-email-emilgoode@gmail.com>
References: <1336661600-2409-1-git-send-email-emilgoode@gmail.com>
Date: Mon, 14 May 2012 11:24:29 +0900
Message-ID: <CAAQKjZNbu9E+bpt0cC8OiRhcGFe13E17bVU_ZY2EeLCzNpSavA@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Include missing linux/types.h in header
From: InKi Dae <daeinki@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/10 Emil Goode <emilgoode@gmail.com>:
> Include the linux/types.h file where used types are declared.
>
> Sparse gives the following warning:
> /usr/include/drm/exynos_drm.h:92:
>        found __[us]{8,16,32,64} type without
>        #include <linux/types.h>
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  include/drm/exynos_drm.h |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
> index e478de4..7eb7ae7 100644
> --- a/include/drm/exynos_drm.h
> +++ b/include/drm/exynos_drm.h
> @@ -29,6 +29,8 @@
>  #ifndef _EXYNOS_DRM_H_
>  #define _EXYNOS_DRM_H_
>
> +#include <linux/types.h>
> +

applied.

Thanks,
Inki Dae

>  /**
>  * User-desired buffer creation information structure.
>  *
> --
> 1.7.10
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
