Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1L1T0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 14:26:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65472 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1L1T0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 14:26:11 -0500
Message-ID: <4EFB6D4F.6070002@gmail.com>
Date: Wed, 28 Dec 2011 21:26:07 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all:
I have two machines with btrfs, that give me the "blocked for more than 
120 seconds" message. After that I cannot write anything to disk, i am 
unable to unmount the btrfs filesystem and i can only reboot with 
sysrq-trigger.

It always happens when i write many files with rsync over network. When 
i used 3.2rc6 it happened randomly on both machines after 50-500gb of 
writes. with rc7 it happens after much less writes, probably 10gb or so, 
but only on machine 1 for the time being. machine 2 has not crashed yet 
after 200gb of writes and I am still testing that.

machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs 
filesystem that lies on a 10TB md raid5. mount options 
compress=zlib,compress-force

machine 2: btrfs over md raid 5 (4x2TB)=5.5TB filesystem. mount options 
compress=zlib,compress-force

pastebins:

machine1:
3.2rc7 http://pastebin.com/u583G7jK
3.2rc6 http://pastebin.com/L12TDaXa

machine2:
3.2rc6 http://pastebin.com/khD0wGXx
3.2rc7 (not crashed yet)
