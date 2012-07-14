Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2GNISY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 04:18:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:47466 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab2GNISR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 04:18:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177250367"
Date: Sat, 14 Jul 2012 16:18:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH UPDATED 6/6] workqueue: reimplement WQ_HIGHPRI using a
 separate worker_pool
Message-ID: <20120714081802.GA30812@localhost>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-7-git-send-email-tj@kernel.org>
 <20120714035650.GC5638@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714035650.GC5638@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> v2: nr_running indexing bug in get_pool_nr_running() fixed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Josh Hunt <joshhunt00@gmail.com>
> LKML-Reference: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> ---
> git branch updated accordingly.  Thanks.

It works now, thank you very much!

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

