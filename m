Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1HCEGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:06:20 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37725 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1HCEGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:06:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkDAILGOE55LCkBgWdsb2JhbABCp1oVAQEWJiWBQAEBBTocIxAIAxguFCUDIRPGbw6GNASjcQ
Date: Wed, 3 Aug 2011 14:06:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
Message-ID: <20110803040613.GJ12870@dastard>
References: <4E38C314.8070305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E38C314.8070305@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 11:40:04AM +0800, Gui Jianfeng wrote:
> Hi,
> 
> I ran a fio test to simulate qemu-kvm io behaviour.
> When job number is greater than 2, IO performance is
> really bad.
> 
> 1 thread: aggrb=15,129KB/s
> 4 thread: aggrb=1,049KB/s
> 
> Kernel: lastest upstream
> 
> Any idea?
> 
> ---
> [global]
> runtime=30
> time_based=1
> size=1G
> group_reporting=1
> ioengine=posixaio
> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
> thread=1
> 
> [kvmio-1]
> description=kvmio-1
> numjobs=4
> rw=write
> bs=4k
> direct=1
> filename=/mnt/sda4/1G.img

What filesystem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
