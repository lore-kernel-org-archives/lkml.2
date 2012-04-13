Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2DMI7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:59:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52804 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961Ab2DMI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:59:10 -0400
Date: Fri, 13 Apr 2012 10:59:56 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20120413085955.GA4525@phenom.ffwll.local>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>
References: <20120413133817.f8bbf0f6d95ada9f86b93800@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413133817.f8bbf0f6d95ada9f86b93800@canb.auug.org.au>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 01:38:17PM +1000, Stephen Rothwell wrote:
> Hi Dave,
> 
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/i915/intel_i2c.c between commit 6a562e3daee2 ("Revert
> "drm/i915: reenable gmbus on gen3+ again"") from Linus' tree and commits
> 0fb3f969c868 ("drm/i915: enable gmbus on gen2") and 2ed06c93a1fc
> ("drm/i915/intel_i2c: gmbus disabled and reserved ports are invalid")
> from the drm tree.
> 
> I just used the drm tree version.

That's correct, gmbus is too broken for 3.4, but we already have quite a
few fixes for known issues queued for 3.5, so leaving it enabled there is
the right thing for -next. I plan to do a backmerge as soon as -rc3 is out
there, I have a few more patches for drm-intel-next that depend/conflict
with new patches merged to Linus' tree.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
