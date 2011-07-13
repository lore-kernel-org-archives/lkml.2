Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1GMUS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:18:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:47546 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1GMUS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:18:27 -0400
Message-Id: <e0d58a$oau9r@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,526,1304319600"; 
   d="scan'208";a="25524539"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Add quirk to disable SSC on Lenovo U160 LVDS
To: Keith Packard <keithp@keithp.com>,
        "drivers, Intel" <Intel-gfx@lists.freedesktop.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <yuntyaq7xjb.fsf@aiko.keithp.com>
References: <yuntyaq7xjb.fsf@aiko.keithp.com>
Date: Wed, 13 Jul 2011 21:18:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 13:09:28 -0700, "Keith Packard" <keithp@keithp.com> wrote:
Non-text part: multipart/signed
> 
> We've tried several times to make this machine 'just work', but every
> patch that does causes many other machines to fail. This adds a quirk
> which special cases this hardware and forces ssc to be
> disabled. There's no way to override this from the command line; that
> would be a significantly more invasive change.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> Tested-by: Robse <rob-se@live.de>

References: https://bugs.freedesktop.org/show_bug.cgi?id=36656
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

-- 
Chris Wilson, Intel Open Source Technology Centre
