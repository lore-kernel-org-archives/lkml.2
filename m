Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0KCVsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:48:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:37320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab0KCVsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:48:17 -0400
Message-Id: <5b55a1$iidall@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,291,1286175600"; 
   d="scan'208";a="623291061"
Date: Wed, 03 Nov 2010 21:48:13 +0000
To: Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH] i915: reprogram power monitoring registers on resume
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101103202757.GJ8332@bombadil.infradead.org>
References: <20101103202757.GJ8332@bombadil.infradead.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010 16:27:57 -0400, Kyle McMartin <kyle@mcmartin.ca> wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Fixes issue where i915_gfx_val was reporting values several
> orders of magnitude higher than physically possible (without
> leaving scorch marks on my thighs at least.)

Applied to -fixes, thanks.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
