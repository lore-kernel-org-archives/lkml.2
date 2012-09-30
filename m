Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2I3Hju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:39:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57364 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2I3Hjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:39:49 -0400
Date: Sun, 30 Sep 2012 16:39:42 +0900
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] workqueue: remove WORKER_PREP from rescuer
Message-ID: <20120930073942.GC10383@mtj.dyndns.org>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
 <1348680043-5077-4-git-send-email-laijs@cn.fujitsu.com>
 <20120926182402.GD12544@google.com>
 <50657611.3070801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50657611.3070801@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 28, 2012 at 06:04:01PM +0800, Lai Jiangshan wrote:
> On 09/27/2012 02:24 AM, Tejun Heo wrote:
> > On Thu, Sep 27, 2012 at 01:20:34AM +0800, Lai Jiangshan wrote:
> >> There is no reason to use WORKER_PREP, remove it from rescuer.
> >>
> >> And there is no reason to set it so early in alloc_worker(),
> >> move "worker->flags = WORKER_PREP" to start_worker().
> > 
> > Merge this with the patch to add RESCUER to NOT_RUNNING?
> 
> Don't merge. the change log is not good.
> I should list all the purposes of WORKER_PREP(I did it in my note),
> and then we can claim that we don't need to add WORKER_PREP show early.
> 
> These two patches do different things.

Hmmm?  You're replacing WORKER_PREP with RESCUER for NOT_RUNNING
marking.  I don't see why they need to be separate patches.  Just
explain what's going on in the commit message.

Thanks.

-- 
tejun
