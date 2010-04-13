Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0DMGvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:51:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39563 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0DMGvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:51:41 -0400
Date: Tue, 13 Apr 2010 08:51:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Divyesh Shah <dpshah@google.com>, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Subject: Re: [PATCH] blkio: Changes to IO controller additional stats
	patches
Message-ID: <20100413065139.GT27497@kernel.dk>
References: <20100409032635.24936.21960.stgit@austin.mtv.corp.google.com> <20100409063129.GD10103@kernel.dk> <4BC406ED.9000008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC406ED.9000008@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13 2010, Gui Jianfeng wrote:
> Jens Axboe wrote:
> > On Thu, Apr 08 2010, Divyesh Shah wrote:
> >> that include some minor fixes and addresses all comments.
> > 
> > Thanks, applied to 2.6.35.
> 
> Hi Jens,
> 
> Do not see this patch and other IO controller stats patches in 
> for-2.6.35 branch. :)

They were stuck on my workstation, apparently forgot to push them out
before the weekend. Please check now and report if you think bits are
missing :-)

-- 
Jens Axboe

