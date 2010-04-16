Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0DPHSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:18:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab0DPHSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:18:15 -0400
Message-ID: <4BC80EFA.8060302@cn.fujitsu.com>
Date: Fri, 16 Apr 2010 15:17:14 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io-controller: including "linux/sched.h"
References: <4BC805C9.8020802@cn.fujitsu.com> <20100416064939.GE27497@kernel.dk>
In-Reply-To: <20100416064939.GE27497@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Apr 16 2010, Gui Jianfeng wrote:
>> Include sched.h explicitly since sched_clock() is called.
> 
> Why is it using sched_clock(), btw? It would seem more appropriate to
> use ktime.

I guess the reason is it's easy to use. :) 
Divyesh, right?

Gui
> 

