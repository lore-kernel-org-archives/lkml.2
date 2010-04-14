Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0DNJVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:21:37 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45437 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab0DNJVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:21:36 -0400
Date: Wed, 14 Apr 2010 11:21:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, nauman@google.com,
       ctalbott@google.com
Subject: Re: [PATCH] blkio: Fix compile errors
Message-ID: <20100414092134.GL27497@kernel.dk>
References: <20100413214425.10757.20478.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413214425.10757.20478.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13 2010, Divyesh Shah wrote:
> Fixes compile errors in blk-cgroup code for empty_time stat and a merge fix in
> CFQ. The first error was when CONFIG_DEBUG_CFQ_IOSCHED is not set.

Thanks, applied.

-- 
Jens Axboe

