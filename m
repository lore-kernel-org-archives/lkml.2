Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3AHSIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:08:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab3AHSIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:08:11 -0500
Date: Tue, 8 Jan 2013 13:08:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 21/24] blkcg: make blkcg_print_blkgs() grab q locks
 instead of blkcg lock
Message-ID: <20130108180804.GC29933@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
 <1356726946-26037-22-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-22-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:43PM -0800, Tejun Heo wrote:
> Instead of holding blkcg->lock while walking ->blkg_list and executing
> prfill(), RCU walk ->blkg_list and hold the blkg's queue lock while
> executing prfill().  This makes prfill() implementations easier as
> stats are mostly protected by queue lock.
> 
> This will be used to implement hierarchical stats.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
