Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1HCG5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:57:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab1HCG5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:57:31 -0400
Message-ID: <4E38D8B7.70006@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 13:12:23 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
References: <4E38C314.8070305@cn.fujitsu.com> <20110803040613.GJ12870@dastard> <4E38D2F5.5050702@cn.fujitsu.com>
In-Reply-To: <4E38D2F5.5050702@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 13:11:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 13:11:05,
	Serialize complete at 2011-08-03 13:11:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-8-3 12:47, Gui Jianfeng wrote:
> On 2011-8-3 12:06, Dave Chinner wrote:
>> On Wed, Aug 03, 2011 at 11:40:04AM +0800, Gui Jianfeng wrote:
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
>>
>> What filesystem?
> 
> Ext4

BTW, even if on Ext3, the problem is still there.

Thanks,
Gui

> 
> Thanks,
> Gui
> 
>>
>> Cheers,
>>
>> Dave.
> 


