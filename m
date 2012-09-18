Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2IRRDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:03:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58622 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2IRRDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:03:10 -0400
Date: Tue, 18 Sep 2012 10:03:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [V2 for-next PATCH 0/7] workqueue: async idle rebinding and
 cleanup for hotplug
Message-ID: <20120918170304.GA8474@google.com>
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
 <5058419A.5050904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5058419A.5050904@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 05:40:42PM +0800, Lai Jiangshan wrote:
> On 09/17/2012 11:46 PM, Lai Jiangshan wrote:
> > Patch1 fix new found possible bug.
> > 
> > Patch2 use async algorithm to replace the synchronous algorithm to rebind
> > idle workers.
> > 
> > The synchronous algorithm requires 3 hand shakes, it introduces much
> > complicated. 
> > 
> > The new async algorithm does not do any synchronization. it removes
> > the idle workers from idle_list to ensure the local-wake-up is correct
> > instead.
> > 
> > Patch3-7 do simple cleanup
> > 
> > Patch2-7 are ready for for-next. I have other devlopment and cleanup for workqueue,
> > should I wait this patchset merged or send them at the same time?
> 
> Hello, Tejun:
> 
> Please defer Patch3-7, because they conflict with the merged one.
> 
> Could you please review and merge the the Patch2(async idle rebinding).
> I have made some effort to write/review/check it.

I merged 2-7 to for-3.7.  I edited descriptions and comments somewhat
but everything else looked good to me.

Thanks.

-- 
tejun
