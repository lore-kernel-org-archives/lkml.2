Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1HHQbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:31:51 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40928 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753376Ab1HHQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:31:50 -0400
Date: Mon, 8 Aug 2011 09:31:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/4] drm/i915: Fix PCH port pipe select in
 CPT disable paths
Message-ID: <20110808093137.5ed7b8ba@jbarnes-desktop>
In-Reply-To: <1312653248-3487-4-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
	<1312653248-3487-4-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  6 Aug 2011 10:54:07 -0700
Keith Packard <keithp@keithp.com> wrote:

> CPT pipe select is different from previous generations (using two bits
> instead of one). All of the paths from intel_disable_pch_ports were
> not making this distinction.
> 
> Mode setting with pipe A turned off would then also force all outputs
> on pipe B to get turned off as the disable code would mistakenly
> decide that all of these outputs were on pipe A and turn them off.
> 
> This is an extension of the CPT DP disable fix (why didn't I fix this then?)
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h      |   13 ++-----
>  drivers/gpu/drm/i915/intel_display.c |   60 ++++++++++++++++++++++++++++++---
>  2 files changed, 58 insertions(+), 15 deletions(-)
> 

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
