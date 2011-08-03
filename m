Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1HCIXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:23:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42654 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1HCIWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <4E3902C7.9050907@cn.fujitsu.com>
References: <4E38C314.8070305@cn.fujitsu.com>
	<CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com>
	<4E3902C7.9050907@cn.fujitsu.com>
Date: Wed, 3 Aug 2011 16:22:50 +0800
X-Google-Sender-Auth: ileHEiI947M7VWHpw-R3_fN9bnI
Message-ID: <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com>
Subject: Re: fio posixaio performance problem
From: Shaohua Li <shli@kernel.org>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
> On 2011-8-3 15:38, Shaohua Li wrote:
>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
>>> Hi,
>>>
>>> I ran a fio test to simulate qemu-kvm io behaviour.
>>> When job number is greater than 2, IO performance is
>>> really bad.
>>>
>>> 1 thread: aggrb=15,129KB/s
>>> 4 thread: aggrb=1,049KB/s
>>>
>>> Kernel: lastest upstream
>>>
>>> Any idea?
>>>
>>> ---
>>> [global]
>>> runtime=30
>>> time_based=1
>>> size=1G
>>> group_reporting=1
>>> ioengine=posixaio
>>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>>> thread=1
>>>
>>> [kvmio-1]
>>> description=kvmio-1
>>> numjobs=4
>>> rw=write
>>> bs=4k
>>> direct=1
>>> filename=/mnt/sda4/1G.img
>> Hmm, the test runs always about 15M/s at my side regardless how many threads.
>
> CFQ£¿
yes.

> what's the slice_idle value?
default value. I didn't change it.
