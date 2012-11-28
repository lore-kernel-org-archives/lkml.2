Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2K1P6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:58:20 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34797 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752496Ab2K1P6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:58:18 -0500
Message-ID: <1354118273.29762.5.camel@joe-AO722>
Subject: Re: [PATCH] drm: tegra: Add maintainers entry
From: Joe Perches <joe@perches.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1354101017-31844-1-git-send-email-thierry.reding@avionic-design.de>
References: <1354101017-31844-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 28 Nov 2012 07:57:53 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-28 at 12:10 +0100, Thierry Reding wrote:
> Add myself as the maintainer of the NVIDIA Tegra DRM driver.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -2504,6 +2504,14 @@ S:	Supported
>  F:	drivers/gpu/drm/exynos
>  F:	include/drm/exynos*
>  
> +NVIDIA TEGRA DRM DRIVER

Alphabetic order please
Maybe DRM DRIVER FOR NVIDIA TEGRA if you really want
to use this file location

> +M:	Thierry Reding <thierry.reding@avionic-design.de>
> +L:	dri-devel@lists.freedesktop.org
> +T:	git://gitorious.org/thierryreding/linux.git

T:	git git://gitorious.org/thierryreding/linux.git

> +S:	Maintained
> +F:	drivers/gpu/drm/tegra

F:	drivers/gpu/drm/tegra/



