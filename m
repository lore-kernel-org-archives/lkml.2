Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0DIGg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:36:29 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47845 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab0DIGg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:36:28 -0400
Date: Fri, 9 Apr 2010 08:36:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH 0/3] blkio: More IO controller stats - always-on and
	debug-only
Message-ID: <20100409063626.GE10103@kernel.dk>
References: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08 2010, Divyesh Shah wrote:
> The following patchset implements additional per-cgroup IO controller stats.
> Some of these should be enabled for debugging only.
> 
> These stats have helped us debug issues with earlier IO controller
> versions and should be useful now as well.
> We've been using these stats for monitoring and debugging problems after the
> fact as these stats can be collected and stored for later use.

Applied, thanks Divyesh.

-- 
Jens Axboe

