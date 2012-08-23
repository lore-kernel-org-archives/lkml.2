Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab2HWIN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:13:29 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:45284 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933655Ab2HWINT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:13:19 -0400
X-Greylist: delayed 979 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 04:13:19 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] i915: use alloc_ordered_workqueue() instead of explicit UNBOUND w/ max_active = 1
To: Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <20120822234057.GR19212@google.com>
References: <20120822234057.GR19212@google.com>
Date: Thu, 23 Aug 2012 08:56:37 +0100
X-Originating-IP: 78.156.73.22
Message-ID: <1345708607_3773@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012 16:40:57 -0700, Tejun Heo <tj@kernel.org> wrote:
> This is an equivalent conversion and will ease scheduled removal of
> WQ_NON_REENTRANT.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
