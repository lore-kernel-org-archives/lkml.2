Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0GVVPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:15:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab0GVVPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:15:45 -0400
Subject: Re: [PATCH 6/7] drm: use workqueue instead of slow-work
From: Dave Airlie <airlied@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: sfrench@samba.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dhowells@redhat.com, anton@samba.org,
        swhiteho@redhat.com
In-Reply-To: <4C48ADEA.8060009@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
	 <1279658102-20069-7-git-send-email-tj@kernel.org>
	 <4C48ADEA.8060009@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 07:11:38 +1000
Message-ID: <1279833098.9197.1.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 22:45 +0200, Tejun Heo wrote:
> On 07/20/2010 10:35 PM, Tejun Heo wrote:
> > Workqueue can now handle high concurrency.  Convert drm_crtc_helper to
> > use system_nrt_wq instead of slow-work.  The conversion is mostly
> > straight forward.  One difference is that drm_helper_hpd_irq_event()
> > no longer blocks and can be called from any context.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: David Airlie <airlied@linux.ie>
> 
> David, can you please review the change?

Yes seems fine to me, in as much as I understand the difference between
slow-work and workqueue, but if you say one replaces the other correctly
now I'm happy for you to carry this patch.

Acked-by: Dave Airlie <airlied@linux.ie>

Dave.
> 
> Thanks.
> 


