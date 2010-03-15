Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab0COPLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:11:51 -0400
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:42200 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164Ab0COPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:11:46 -0400
Message-ID: <4B9E46F9.8090209@sandeen.net>
Date: Mon, 15 Mar 2010 09:40:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
 assfail+0x1b/0x20 SS:ESP 0068:f687bf14
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Specifications:
> 
> 2.6.33
> 32bit
> Debian Testing
> 
> On Mar 14th, my server hung up:
> 
> Mar 14 00:00:22 server1 kernel: [488470.189675] ------------[ cut here
> ]------------
> Mar 14 00:00:22 server1 kernel: [488470.189679] invalid opcode: 0000
> [#1] SMP
> Mar 14 00:00:22 server1 kernel: [488470.189681] last sysfs file:
> /sys/devices/pci0000:00/0000:00:0e.0/host0/target0:0:0/0:0:0:0/block/sda/uevent
> 
> Mar 14 00:00:22 server1 kernel: [488470.189704] Process xfssyncd (pid:
> 584, ti=f687a000 task=f70fa400 task.ti=f687a000)
> Mar 14 00:00:22 server1 kernel: [488470.189705] Stack:
> Mar 14 00:00:22 server1 kernel: [488470.189721] Call Trace:
> Mar 14 00:00:22 server1 kernel: [488470.189739] Code: 00 e8 ea e5 01 00
> 83 c4 14 c3 8d b6 00 00 00 00 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24
> 04 c7 04 24 30 ab 42 c1 e8 7c 11 1c 00 <0f> 0b eb fe 90 55 57 89 cf 56
> 89 c6 b8 80 b0 52 c1 83 e6 07 53
> Mar 14 00:00:22 server1 kernel: [488470.189739] EIP: [<c11a018b>]
> assfail+0x1b/0x20 SS:ESP 0068:f687bf14
> 
> Is this a bug related to AMD (CPU) or XFS?

Hard to know without seeing the rest of the stack trace, is this all you got?

You hit an assertion failure in xfs.

Are you running with CONFIG_XFS_DEBUG?

-Eric

> Justin.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

