Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2JGUsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 16:48:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48552 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2JGUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 16:48:32 -0400
Date: Sun, 7 Oct 2012 22:49:29 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: remove duplicated include from intel_modes.c
Message-ID: <20121007204929.GD7352@phenom.ffwll.local>
Mail-Followup-To: Wei Yongjun <weiyj.lk@gmail.com>, airlied@linux.ie,
	yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <CAPgLHd-jRBwCsmN-sVJAcnedx_t59TurCV5aepVteD-mvUvphQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-jRBwCsmN-sVJAcnedx_t59TurCV5aepVteD-mvUvphQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 09:26:35PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied to drm-intel-next, thanks.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
