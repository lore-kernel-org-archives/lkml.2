Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1APKr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 05:47:58 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44640 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab1APKr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 05:47:57 -0500
Date: Sun, 16 Jan 2011 12:47:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: fixup headers_check
Message-ID: <20110116104751.GB2456@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1295174783-4099-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295174783-4099-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 16, 2011 at 12:46:22PM +0200, Felipe Balbi wrote:
> Drop the following headers_check errors:
> /linux-2.6/usr/include/drm/drm_mode.h:85: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/i915_drm.h:120: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/mga_drm.h:260: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/radeon_drm.h:758: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/via_drm.h:117: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Felipe Balbi <balbi@ti.com>

$SUBJECT shouldn't have number actually. Git added those automatically.
Oh well, not a big deal.

-- 
balbi
