Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab2D0OnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823Ab2D0OnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:43:06 -0400
Date: Fri, 27 Apr 2012 10:42:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 02/11] blkcg: __blkg_lookup_create() doesn't have to fail
 on radix tree preload failure
Message-ID: <20120427144258.GI10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335477561-11131-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:59:12PM -0700, Tejun Heo wrote:
> __blkg_lookup_create() currently fails if radix_tree_preload() fails;
> however, preload failrue doesn't imply insertion failure.  Don't fail
> __blkg_lookup_create() on preload failure.
> 

Hi Tejun,

If we are going to try the insertion anyway irrespective of the fact
whether preload succeeded or not, they why call radix_tree_preload()
at all? How does that help?

Thanks
Vivek
