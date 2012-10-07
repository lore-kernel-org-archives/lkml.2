Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2JGHQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:16:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55432 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2JGHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:16:12 -0400
Message-ID: <50712AAA.5030807@gmail.com>
Date: Sun, 07 Oct 2012 09:09:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
CC: Vyacheslav Dubeyko <slava@dubeyko.com>, jaegeuk.kim@samsung.com,
        Al Viro <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>  <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com> <1349553966.12699.132.camel@kjgkr>
In-Reply-To: <1349553966.12699.132.camel@kjgkr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/10/2012 22:06, Jaegeuk Kim ha scritto:
> 2012-10-06 (토), 17:54 +0400, Vyacheslav Dubeyko:
>> Hi Jaegeuk,
>
> Hi.
> We know each other, right? :)
>
>>
>>> From:	 	김재극 <jaegeuk.kim@samsung.com>
>>> To:	 	viro@zeniv.linux.org.uk, 'Theodore Ts'o' <tytso@mit.edu>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, chur.lee@samsung.com, cm224.lee@samsung.com, jaegeuk.kim@samsung.com, jooyoung.hwang@samsung.com
>>> Subject:	 	[PATCH 00/16] f2fs: introduce flash-friendly file system
>>> Date:	 	Fri, 05 Oct 2012 20:55:07 +0900
>>>
>>> This is a new patch set for the f2fs file system.
>>>
>>> What is F2FS?
>>> =============
>>>
>>> NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
>>> been widely being used for ranging from mobile to server systems. Since they are
>>> known to have different characteristics from the conventional rotational disks,
>>> a file system, an upper layer to the storage device, should adapt to the changes
>>> from the sketch.
>>>
>>> F2FS is a new file system carefully designed for the NAND flash memory-based storage
>>> devices. We chose a log structure file system approach, but we tried to adapt it
>>> to the new form of storage. Also we remedy some known issues of the very old log
>>> structured file system, such as snowball effect of wandering tree and high cleaning
>>> overhead.
>>>
>>> Because a NAND-based storage device shows different characteristics according to
>>> its internal geometry or flash memory management scheme aka FTL, we add various
>>> parameters not only for configuring on-disk layout, but also for selecting allocation
>>> and cleaning algorithms.
>>>
>>
>> What about F2FS performance? Could you share benchmarking results of the new file system?
>>
>> It is very interesting the case of aged file system. How is GC's implementation efficient? Could you share benchmarking results for the very aged file system state?
>>
>
> Although I have benchmark results, currently I'd like to see the results
> measured by community as a black-box. As you know, the results are very
> dependent on the workloads and parameters, so I think it would be better
> to see other results for a while.
> Thanks,
>

1) Actually it's a strange approach. If you have got any results you 
should share them with the community explaining how (the workload, hw 
and so on) your benchmark works and the specific condition. I really 
don't like the approach "I've got the results but I don't say anything, 
if you want a number, do it yourself".
2) For a new filesystem you should send the patches to linux-fsdevel.
3) It's not clear the pros/cons of your filesystem, can you share with 
us the main differences with the current fs already in mainline? Or is 
it a company secret?

Marco
