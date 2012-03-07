Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2CGL6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:58:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:41432 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2CGL6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:58:39 -0500
Message-Id: <e0d58a$3h3kiq@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="118608474"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/9] drm/i915/intel_i2c: cleanup
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1331121050-17857-2-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-2-git-send-email-djkurtz@chromium.org>
Date: Wed, 07 Mar 2012 11:58:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:42 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> 80 col, spaces around operators and other basic cleanup.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/gpu/drm/i915/intel_i2c.c |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
> index d30cccc..a94e383 100644
> --- a/drivers/gpu/drm/i915/intel_i2c.c
> +++ b/drivers/gpu/drm/i915/intel_i2c.c
> @@ -236,8 +236,9 @@ gmbus_xfer(struct i2c_adapter *adapter,
>  	int i, reg_offset;
>  
>  	if (bus->force_bit)
> -		return intel_i2c_quirk_xfer(dev_priv,
> -					    bus->force_bit, msgs, num);
> +		return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs,
> +					    num);
> +
NAK just on that around. The new line was put there for a reason as
there is a distinction in the types of parameters, it visually grouped
the control arguments from the object.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
