Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761Ab2FVI5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:57:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59064 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761746Ab2FVI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:57:20 -0400
Date: Fri, 22 Jun 2012 10:58:49 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13
Message-ID: <20120622084138.GA4931@phenom.ffwll.local>
Mail-Followup-To: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1340350987-24699-1-git-send-email-sjoerd.simons@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340350987-24699-1-git-send-email-sjoerd.simons@collabora.co.uk>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 09:43:07AM +0200, Sjoerd Simons wrote:
> This box claims to have an LVDS interface but doesn't
> actually have one.
> 
> Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
