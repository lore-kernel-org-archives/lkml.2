Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2LRTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:16:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab2LRTQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:16:55 -0500
Date: Tue, 18 Dec 2012 14:16:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 09/12] cfq-iosched: enable full blkcg hierarchy support
Message-ID: <20121218191645.GA25908@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-10-git-send-email-tj@kernel.org>
 <20121218184022.GC24050@redhat.com>
 <20121218191055.GN1844@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218191055.GN1844@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:10:55AM -0800, Tejun Heo wrote:
> Hey, Vivek.
> 
> On Tue, Dec 18, 2012 at 01:40:23PM -0500, Vivek Goyal wrote:
> > Can we update Documentation/blkio-controller.txt file to explain all
> > this. Also it would be nice to also explain the case of a group having
> > both tasks and groups as child and then how shares will be calculated.
> > There we can also explain the notion of group->weight and
> > group->leaf_weight.
> 
> Yeah, sure thing.  Other than documentation / field names, do things
> look okay to you?  If so, I'll post updated round once -rc1 happens.

Hi Tejun,

Yes, in general things look good to me with this patch.

/me is wondering how to get a response from cpu controller folks.

Thanks
Vivek

