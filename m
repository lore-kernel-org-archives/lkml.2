Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2C1SyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:54:17 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:54320 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750845Ab2C1SyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:54:16 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 7/7 v6] drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332959199-32161-8-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org> <1332959199-32161-8-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:53:57 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332960849_131204@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 02:26:39 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> The POSTING_READ() calls were originally added to make sure the writes
> were flushed before any timing delays and across loops.
> Now that the code has settled a bit, let's remove them.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
