Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2DWITd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:19:33 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:44816 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751721Ab2DWITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:19:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH v2 2/2] drm/i915: fix integer overflow in i915_gem_do_execbuffer()
To: Xi Wang <xi.wang@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, security@kernel.org,
        Xi Wang <xi.wang@gmail.com>, stable@vger.kernel.org
In-Reply-To: <1335168402-25174-2-git-send-email-xi.wang@gmail.com>
References: <1335168402-25174-1-git-send-email-xi.wang@gmail.com> <1335168402-25174-2-git-send-email-xi.wang@gmail.com>
Date: Mon, 23 Apr 2012 09:18:44 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1335169153_26005@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012 04:06:42 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> On 32-bit systems, a large args->num_cliprects from userspace via ioctl
> may overflow the allocation size, leading to out-of-bounds access.
> 
> This vulnerability was introduced in commit 432e58ed ("drm/i915: Avoid
> allocation for execbuffer object list").
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
