Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2KIW16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:27:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59101 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2KIW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:27:56 -0500
Message-ID: <509D8369.5000101@wwwdotorg.org>
Date: Fri, 09 Nov 2012 15:27:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de> <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:59 AM, Thierry Reding wrote:
> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
> support for host1x and the two display controllers found on the Tegra20
> SoC. Each display controller can drive a separate RGB/LVDS output.

> diff --git a/Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt b/Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt
> new file mode 100644
> index 0000000..b4fa934
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt

"drm" is a Linux-specific term, so shouldn't really be used as the
directory name for a binding. bindings/gpu/nvidia,tegra20-host1x.txt
would probably be just fine.

Aside from that, the bindings,
Acked-by: Stephen Warren <swarren@nvidia.com>

I don't really know anything about DRM or our display HW, so I haven't
reviewed the code at all. I certainly ack the concept of adding the
driver though! I have asked various other people at NVIDIA to give a
quick review of the code.
