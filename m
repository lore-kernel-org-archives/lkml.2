Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1KSHgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 02:36:50 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:46566 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1KSHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 02:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=whitecape.org; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=whitecape.org;
	 b=Z6pijcbNJo4M9vi4a8x8rpJia/UME/GGdiUfdjiKQkyx2W4uQ0tgmZdgI5PL1
	4N4Yv9q2q2V0s8bACyDljxqaMng0y/7tISsgR1Uz94F+tiaaIwuvcwe5/roCU4hB
	y8HsipT8O5lN6/r+dlht1W8JTIogn/Vj4umi6SDgGbaSUo=
Message-ID: <4EC75CB1.4090900@whitecape.org>
Date: Fri, 18 Nov 2011 23:37:21 -0800
From: Kenneth Graunke <kenneth@whitecape.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: By default, enable RC6 on IVB and
 SNB when reasonable
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
In-Reply-To: <1321684889-18691-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 10:41 PM, Keith Packard wrote:
> RC6 should always work on IVB, and should work on SNB whenever IO
> remapping is disabled. Make the default value for the parameter turn
> it on in these cases. Setting the value to either 0 or 1 will force
> the specified behavior.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
>  drivers/gpu/drm/i915/i915_drv.h      |    2 +-
>  drivers/gpu/drm/i915/intel_display.c |   26 +++++++++++++++++++++++---
>  3 files changed, 26 insertions(+), 6 deletions(-)

Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>

