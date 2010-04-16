Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab0DPGtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:49:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42596 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0DPGtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:49:41 -0400
Date: Fri, 16 Apr 2010 08:49:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io-controller: including "linux/sched.h"
Message-ID: <20100416064939.GE27497@kernel.dk>
References: <4BC805C9.8020802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC805C9.8020802@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16 2010, Gui Jianfeng wrote:
> Include sched.h explicitly since sched_clock() is called.

Why is it using sched_clock(), btw? It would seem more appropriate to
use ktime.

-- 
Jens Axboe

