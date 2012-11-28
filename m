Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab2K1TWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:22:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41862 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab2K1TWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:22:34 -0500
Message-ID: <50B66477.1070202@wwwdotorg.org>
Date: Wed, 28 Nov 2012 12:22:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, Joe Perches <joe@perches.com>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm: tegra: Add maintainers entry
References: <1354130322-24509-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1354130322-24509-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 12:18 PM, Thierry Reding wrote:
> Add myself as the maintainer of the NVIDIA Tegra DRM driver.

Aside from one comment below,

Acked-by: Stephen Warren <swarren@nvidia.com>

> +L:	dri-devel@lists.freedesktop.org

Should linux-tegra@vger.kernel.org also be CC'd so that everything
Tegra-related goes to one place?
