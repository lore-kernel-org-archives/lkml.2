Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2C1Sej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:34:39 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:51914 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758397Ab2C1Sei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:34:38 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/7 v6] drm/i915/intel_i2c: handle zero-length writes
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332959199-32161-2-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org> <1332959199-32161-2-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:34:17 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332959669_130996@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 02:26:33 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> A common method of probing an i2c bus is trying to do a zero-length write.
> Handle this case by checking the length first before decrementing it.
> 
> This is actually important, since attempting a zero-length write is one
> of the ways that i2cdetect and i2c_new_probed_device detect whether
> there is device present on the bus with a given address.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
