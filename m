Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2KMARX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:17:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46105 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KMARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:17:21 -0500
Message-ID: <50A1918E.1000809@wwwdotorg.org>
Date: Mon, 12 Nov 2012 17:17:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] NVIDIA Tegra DRM driver
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 02:55 PM, Thierry Reding wrote:
> This second version of this patch series addresses all the comments
> received so far. Most notably it takes advantage of the debugfs helpers
> provided by the DRM core. Oddly enough this actually increases the line
> count, but that's because the helpers don't fit with the subdevices
> approach as implemented by this driver. However some quick discussions
> with Rob Clark showed that Tegra DRM is not special in this respect but
> other drivers may need the same functionality. Eventually the debugfs
> code could be reworked on top of helpers that are better suited at the
> design of embedded, multi-device DRM drivers.
> 
> Other than that there is some removal of code that was actually supposed
> to go into a later patch because it has dependencies that haven't been
> merged yet and some moving around of #defines and the device tree
> bindings documentation. Finally the driver now uses the DRM core's
> drm_compat_ioctl() instead of a custom and unimplemented (!) version.

The series,

Tested-by: Stephen Warren <swarren@nvidia.com>

(on the Harmony board's HDMI output; I'll test other boards/outputs later).
