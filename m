Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2BZAp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 19:45:57 -0500
Received: from mail.candelatech.com ([208.74.158.172]:60988 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2BZAp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 19:45:56 -0500
Message-ID: <4F4980C2.1080305@candelatech.com>
Date: Sat, 25 Feb 2012 16:45:54 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Compile busted in inode.c (is_compat_task)
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just pulled the latest (3.3.0-rc5), and it fails to build on my
32-bit system.  I can send full .config if the problem is
not obvious...

   CC [M]  fs/autofs4/inode.o
/mnt/diskb/greearb/git/linux-2.6/fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
/mnt/diskb/greearb/git/linux-2.6/fs/autofs4/inode.c:228: error: implicit declaration of function ‘is_compat_task’
make[4]: *** [fs/autofs4/inode.o] Error 1
make[3]: *** [fs/autofs4] Error 2
make[2]: *** [fs] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2
[greearb@build-32 linux-2.6.p4s]$

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
