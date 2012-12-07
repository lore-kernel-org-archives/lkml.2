Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab2LGLuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:50:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:35041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab2LGLuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:50:20 -0500
Message-Id: <6c3329$7hpdt5@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,236,1355126400"; 
   d="scan'208";a="253540261"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH linux-next] i915: intel_set_mode: Reduce stack allocation from 500 bytes to 2 pointers
To: Jani Nikula <jani.nikula@linux.intel.com>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tim Gardner <tim.gardner@canonical.com>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <87zk1qm6cd.fsf@intel.com>
References: <1354815755-83271-1-git-send-email-tim.gardner@canonical.com> <87zk1qm6cd.fsf@intel.com>
Date: Fri, 07 Dec 2012 11:49:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012 13:47:46 +0200, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> 
> On Thu, 06 Dec 2012, Tim Gardner <tim.gardner@canonical.com> wrote:
> > +	if (!saved_mode) {
> > +		pr_err("i915: Could not allocate saved display mode.\n");
> 
> Please use DRM_ERROR().

Truthfully neither, but join the growing petition to get real errorcodes
back to userspace!
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
