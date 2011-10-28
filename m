Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab1J1RU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:20:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:25709 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1J1RU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:20:28 -0400
Message-Id: <f80fcd$2bbqtl@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,419,1315206000"; 
   d="scan'208";a="79031221"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [patch] drm/i915: fix if statement (bogus semi-colon)
To: Keith Packard <keithp@keithp.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <yund3dh9h4t.fsf@aiko.keithp.com>
References: <20111028114241.GA13603@elgon.mountain> <yund3dh9h4t.fsf@aiko.keithp.com>
Date: Fri, 28 Oct 2011 18:20:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011 10:10:26 -0700, Keith Packard <keithp@keithp.com> wrote:
> On Fri, 28 Oct 2011 14:42:41 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > -	if (needs_idle_maps());
> > +	if (needs_idle_maps())
> 
> how embarrassing is that?

Actually it served an ulterior purpose and by exercising the workaround
showed us that it contained a more subtle bug. I believe therefore Ben
did it deliberately ;-)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
