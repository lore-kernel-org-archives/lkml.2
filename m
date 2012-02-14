Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2BNBDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:03:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39354 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2BNBDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:03:14 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-2d-4f39b2c3dbc2
From: Inki Dae <inki.dae@samsung.com>
To: "'Masanari Iida'" <standby24x7@gmail.com>, jy0922.shim@samsung.com,
        sw0312.kim@samsung.com, dri-devel@lists.freedesktop.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
References: <1329142242-2344-1-git-send-email-standby24x7@gmail.com>
In-reply-to: <1329142242-2344-1-git-send-email-standby24x7@gmail.com>
Subject: RE: [PATCH] [trivial] drm: Fix typo in exynos_mixer.c
Date: Tue, 14 Feb 2012 10:02:59 +0900
Message-id: <004901cceab4$64fb85c0$2ef29140$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczqWVXWDkVGgXqeSDmEsHXW0k2q3QAWg0Dg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Masanari Iida [mailto:standby24x7@gmail.com]
> Sent: Monday, February 13, 2012 11:11 PM
> To: inki.dae@samsung.com; jy0922.shim@samsung.com; sw0312.kim@samsung.com;
> dri-devel@lists.freedesktop.org
> Cc: trivial@kernel.org; linux-kernel@vger.kernel.org;
> standby24x7@gmail.com
> Subject: [PATCH] [trivial] drm: Fix typo in exynos_mixer.c
> 
> Correct spelling "sucessful" to "successful" in
> drivers/gpu/drm/exynos/exynos_mixer.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/gpu/drm/exynos/exynos_mixer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c
> b/drivers/gpu/drm/exynos/exynos_mixer.c
> index ac24cff..33afd0c 100644
> --- a/drivers/gpu/drm/exynos/exynos_mixer.c
> +++ b/drivers/gpu/drm/exynos/exynos_mixer.c
> @@ -1044,7 +1044,7 @@ static int mixer_remove(struct platform_device
*pdev)
>  					platform_get_drvdata(pdev);
>  	struct mixer_context *ctx = (struct mixer_context *)drm_hdmi_ctx-
> >ctx;
> 
> -	dev_info(dev, "remove sucessful\n");
> +	dev_info(dev, "remove successful\n");
> 
>  	mixer_resource_poweroff(ctx);
>  	mixer_resources_cleanup(ctx);
> --
> 1.7.6.5

Applied.

Thanks.
Inki Dae.

