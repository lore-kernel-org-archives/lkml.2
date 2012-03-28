Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2C1Sxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:53:45 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:54234 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752420Ab2C1Sxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:53:44 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 6/7 v6] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1332959199-32161-7-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org> <1332959199-32161-7-git-send-email-djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:53:24 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1332960816_131195@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 02:26:38 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Save the GMBUS2 value read while polling for state changes, and then
> reuse this value when determining for which reason the loops were exited.
> This is a small optimization which saves a couple of bus accesses for
> memory mapped IO registers.
> 
> To avoid "assigning in if clause" checkpatch errors", use a ret variable
> to store the wait_for macro return value.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
