Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab2B0F4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:56:45 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34672 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2B0F4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:56:44 -0500
Message-ID: <4F4B1B0C.4040100@linux.vnet.ibm.com>
Date: Mon, 27 Feb 2012 11:26:28 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.mason@oracle.com, kamalesh@linux.vnet.ibm.com
Subject: Re: [BUG] Kernel Bug at fs/btrfs/volumes.c:3638
References: <4F476959.2010400@linux.vnet.ibm.com> <4F487BB5.1060706@cn.fujitsu.com>
In-Reply-To: <4F487BB5.1060706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12022619-5140-0000-0000-000000CF174B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ఫిబ్రవరి 25 శనివారం 2012 ఉ. 11:42, Liu Bo wrote:
> Hi, I guess you're mounting a quite small partition. Given that this 
> oops is in such an early stage, could you please show 1) your 
> mkfs.btrfs options and 2) the log of "btrfs-debug-tree /dev/loop0"? 
> thanks, liubo
Here are the steps with options,

1. dd if=/dev/zero of=<filename.img> bs=1M count=16

2. mkfs.btrfs <filename.img>

3. Corrupt the <filename.img> using 'mangle'

4. mount -t btrfs -o loop <filename.img> <mount point>

5. # btrfs-debug-tree <filename.img>
Couldn't map the block 3221392384
Couldn't read chunk root
unable to open <filename.img>
# btrfs-debug-tree /dev/loop0
Couldn't map the block 3221392384
Couldn't read chunk root
unable to open /dev/loop0

Regards,
R.Nageswara Sastry

