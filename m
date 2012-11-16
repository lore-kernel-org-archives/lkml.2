Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2KPHfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:35:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5821 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2KPHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:35:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 Nov 2012 23:35:38 -0800
Message-ID: <50A5ED93.5080107@nvidia.com>
Date: Fri, 16 Nov 2012 09:38:59 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] NVIDIA Tegra DRM driver
References: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.11.2012 23:28, Thierry Reding wrote:
> This third version of the patch series cleans up some minor issues that
> were found in the previous versions, such as deferred probe not working
> properly and the display remaining enabled after the driver is removed.
> 
> I've also put the two patches in this series into the tegra/drm/for-3.8
> branch of my repository on gitorious[0].

Excellent work. Thanks a lot Thierry!

I tested this and the device tree patches on my Tegra20 board. For both:

Acked-by: Terje Bergstrom <tbergstrom@nvidia.com>
Tested-by: Terje Bergstrom <tbergstrom@nvidia.com>

Best regards,
Terje

