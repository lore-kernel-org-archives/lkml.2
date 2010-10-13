Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0JMMZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:25:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:58239 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0JMMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:25:20 -0400
Message-ID: <4CB5A51F.50709@windriver.com>
Date: Wed, 13 Oct 2010 07:25:03 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the drm tree with the kgdb tree
References: <20101013131303.c044aa88.sfr@canb.auug.org.au>
In-Reply-To: <20101013131303.c044aa88.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Oct 2010 12:25:04.0689 (UTC) FILETIME=[AA3AF210:01CB6AD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 09:13 PM, Stephen Rothwell wrote:
> Hi Dave,
>
> Today's linux-next merge of the drm tree got conflicts in
> drivers/gpu/drm/drm_fb_helper.c, drivers/gpu/drm/i915/intel_display.c,
> drivers/gpu/drm/nouveau/nv04_crtc.c, drivers/gpu/drm/nouveau/nv50_crtc.c,
> drivers/gpu/drm/radeon/atombios_crtc.c,
> drivers/gpu/drm/radeon/radeon_legacy_crtc.c,
> drivers/gpu/drm/radeon/radeon_mode.h and include/drm/drm_crtc_helper.h
> between commit 92b182171492dc1ac626e6f24ff3a7c917217aa0 ("drm,kdb,kms:
> Add an enter argument to mode_set_base_atomic() API") from the kgdb tree
> and commit 413d45d3627be4748058dea697718ed6fb88bd01 ("drm, kdb, kms: Add
> an enter argument to mode_set_base_atomic() API") from the drm tree.
>
> Supposedly the same patch, but not :-(.  I fixed it up by using the
> version from the drm tree (since that has slightly later author date).
> Hope I got it right :-)
>
> Please sort this out.
>   

Thanks Stephen,

There were 3 version of that particular the patch set before things
settled down.  All the drm patches will be removed from my tree and
fixes will propagate via the drm-core-next tree.

Cheers,
Jason.
