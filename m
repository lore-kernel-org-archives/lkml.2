Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab2KPDgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:36:39 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12183 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2KPDgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:36:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 15 Nov 2012 19:36:37 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] NVIDIA Tegra DRM driver
Date: Fri, 16 Nov 2012 12:36:36 +0900
Message-ID: <1480191.1noyT4vz0N@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2012 05:28:21 Thierry Reding wrote:
> This third version of the patch series cleans up some minor issues that
> were found in the previous versions, such as deferred probe not working
> properly and the display remaining enabled after the driver is removed.
> 
> I've also put the two patches in this series into the tegra/drm/for-3.8
> branch of my repository on gitorious[0].

Pulled from your branch and tried to test on my Ventana, but for some reason 
nothing ever gets displayed. The only DRM-related message I ever get in my log 
is

[    0.820483] [drm] Initialized drm 1.1.0 20060810

Things were working perfectly with v2 - has something changed with e.g. the DT 
bindings?

Alex.

