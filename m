Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0DZR1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 13:27:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58998 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0DZR1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 13:27:40 -0400
Date: Mon, 26 Apr 2010 19:27:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Nauman Rafique <nauman@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] blk-cgroup: config options re-arrangement
Message-ID: <20100426172739.GU27497@kernel.dk>
References: <20100422223705.GI3228@redhat.com> <20100426171830.GC3372@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426171830.GC3372@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26 2010, Vivek Goyal wrote:
> On Thu, Apr 22, 2010 at 06:37:05PM -0400, Vivek Goyal wrote:
> > This patch fixes few usability and configurability issues.
> > 
> > o All the cgroup based controller options are configurable from
> >   "Genral Setup/Control Group Support/" menu. blkio is the only exception.
> >   Hence make this option visible in above menu and make it configurable from
> >   there to bring it inline with rest of the cgroup based controllers.
> > 
> 
> Hi Jens,
> 
> Do you have any concerns with this patch? If not, can you please include
> it.

It's queued up, thanks.

-- 
Jens Axboe

