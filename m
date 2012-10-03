Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2JCNGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2JCNGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:06:20 -0400
Date: Wed, 3 Oct 2012 09:06:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org
Subject: Re: [PATCH 01/15] cfq-iosched: Properly name all references to IO
 class
Message-ID: <20121003130613.GC20376@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-2-git-send-email-vgoyal@redhat.com>
 <20121003005429.GA15806@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003005429.GA15806@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:54:29AM +0900, Tejun Heo wrote:

[..]
> > -	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
> > -		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
> > -		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
> > +	return cfqg->service_trees[wl_class][ASYNC_WORKLOAD].count
> > +		+ cfqg->service_trees[wl_class][SYNC_NOIDLE_WORKLOAD].count
> > +		+ cfqg->service_trees[wl_class][SYNC_WORKLOAD].count;
> 
> While at it, maybe move the operator to the end of the preceding line
> like everybody else?

Ok, will do.

Thanks
Vivek
