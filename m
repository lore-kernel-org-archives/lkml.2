Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2HEVA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:00:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58089 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2HEVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:00:25 -0400
Date: Sun, 5 Aug 2012 23:00:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesper Juhl <jj@chaosbits.net>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Fix mem leak in intel_sdvo_write_cmd()
Message-ID: <20120805210044.GE12232@phenom.ffwll.local>
Mail-Followup-To: Jesper Juhl <jj@chaosbits.net>,
	David Airlie <airlied@linux.ie>,
	Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <alpine.LNX.2.00.1207312228270.7100@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207312228270.7100@swampdragon.chaosbits.net>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:31:15PM +0200, Jesper Juhl wrote:
> If the allocation of 'buf' succeeds but the allocation of 'msgs' fails
> we'll return false and leak 'buf' when it goes out of scope.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

I've already merged a similar patch from Alan Cox for -fixes, should land
in 3.6 soonish.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
