Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab0GVVRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:17:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:34813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0GVVRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:17:49 -0400
Message-ID: <4C48B570.6000600@kernel.org>
Date: Thu, 22 Jul 2010 23:17:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: sfrench@samba.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dhowells@redhat.com, anton@samba.org,
        swhiteho@redhat.com
Subject: Re: [PATCH 6/7] drm: use workqueue instead of slow-work
References: <1279658102-20069-1-git-send-email-tj@kernel.org>	 <1279658102-20069-7-git-send-email-tj@kernel.org>	 <4C48ADEA.8060009@kernel.org> <1279833098.9197.1.camel@t60prh>
In-Reply-To: <1279833098.9197.1.camel@t60prh>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 21:17:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 11:11 PM, Dave Airlie wrote:
> On Thu, 2010-07-22 at 22:45 +0200, Tejun Heo wrote:
>> On 07/20/2010 10:35 PM, Tejun Heo wrote:
>>> Workqueue can now handle high concurrency.  Convert drm_crtc_helper to
>>> use system_nrt_wq instead of slow-work.  The conversion is mostly
>>> straight forward.  One difference is that drm_helper_hpd_irq_event()
>>> no longer blocks and can be called from any context.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> Cc: David Airlie <airlied@linux.ie>
>>
>> David, can you please review the change?
> 
> Yes seems fine to me, in as much as I understand the difference between
> slow-work and workqueue, but if you say one replaces the other correctly
> now I'm happy for you to carry this patch.
> 
> Acked-by: Dave Airlie <airlied@linux.ie>

Thank you.  Will push out to #for-next.

-- 
tejun
