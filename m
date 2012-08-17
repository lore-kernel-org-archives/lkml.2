Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab2HQPep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:34:45 -0400
Received: from mga07.intel.com ([143.182.124.22]:48190 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754164Ab2HQPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <1344918891-6283-4-git-send-email-keithp@keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-4-git-send-email-keithp@keithp.com>
Date: Fri, 17 Aug 2012 16:34:35 +0100
Message-ID: <CAPX-8+-0JisF0hgzQ50fZj3HNtZc7gpXAC=2o4u+DmCgQ3NLxQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Delay between FDI link training
 tries. Clear FDI_RX_IIR before training
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:
> Just a bit of cleanup; it appears to have no effect.
>
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Clearing the locking bit in FDI_RX_IIR looks like a good move and
waiting between tries can't hurt, looks good to me.

Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

-- 
Damien
