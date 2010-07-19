Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720Ab0GSIBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:01:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab0GSIBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:01:40 -0400
Message-ID: <4C44066A.3080701@cn.fujitsu.com>
Date: Mon, 19 Jul 2010 16:01:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        zheng.yan@oracle.com, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1353
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007141725.24507.johannes.hirte@fem.tu-ilmenau.de> <20100715001104.GF30737@dastard> <201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
In-Reply-To: <201007152014.52924.johannes.hirte@fem.tu-ilmenau.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 20:14:51 +0200, Johannes Hirte wrote:
> Am Donnerstag 15 Juli 2010, 02:11:04 schrieb Dave Chinner:
>> On Wed, Jul 14, 2010 at 05:25:23PM +0200, Johannes Hirte wrote:
>>> Am Donnerstag 08 Juli 2010, 16:31:09 schrieb Chris Mason:
>>> I'm not sure if btrfs is to blame for this error. After the errors I
>>> switched to XFS on this system and got now this error:
>>>
>>> ls -l .kde4/share/apps/akregator/data/
>>> ls: cannot access .kde4/share/apps/akregator/data/feeds.opml: Structure
>>> needs cleaning
>>> total 4
>>> ?????????? ? ?    ?        ?            ? feeds.opml
>>
>> What is the error reported in dmesg when the XFS filesytem shuts down?
>
> Nothing. I double checked the logs. There are only the messages when mounting
> the filesystem. No other errors are reported than the inaccessible file and the
> output from xfs_check.

Is there anything wrong with your disks or memory?
Sometimes the bad memory can break the filesystem. I have met this kind of problem
some time ago.

If there is no problem with your disk and memory, Could you tell us the parameter of
mkfs.btrfs and mount?

Thanks
Miao Xie
