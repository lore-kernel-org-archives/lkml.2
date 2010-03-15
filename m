Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab0COOoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:44:32 -0400
Received: from lucidpixels.com ([75.144.35.66]:58197 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042Ab0COOob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:44:31 -0400
Date: Mon, 15 Mar 2010 10:44:30 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Eric Sandeen <sandeen@sandeen.net>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.33 crash: invalid opcode: 0000 [#1] SMP: EIP: [<c11a018b>]
 assfail+0x1b/0x20 SS:ESP 0068:f687bf14
In-Reply-To: <4B9E46F9.8090209@sandeen.net>
Message-ID: <alpine.DEB.2.00.1003151042390.9496@p34.internal.lan>
References: <alpine.DEB.2.00.1003150528060.6999@p34.internal.lan> <4B9E46F9.8090209@sandeen.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Mar 2010, Eric Sandeen wrote:

> Justin Piszcz wrote:
>> Specifications:
>>
>> 2.6.33
>> 32bit
>> Debian Testing
>>
>> On Mar 14th, my server hung up:
>>
>> Mar 14 00:00:22 server1 kernel: [488470.189675] ------------[ cut here
>> ]------------
>> Mar 14 00:00:22 server1 kernel: [488470.189679] invalid opcode: 0000
>> [#1] SMP
>> Mar 14 00:00:22 server1 kernel: [488470.189681] last sysfs file:
>> /sys/devices/pci0000:00/0000:00:0e.0/host0/target0:0:0/0:0:0:0/block/sda/uevent
>>
>> Mar 14 00:00:22 server1 kernel: [488470.189704] Process xfssyncd (pid:
>> 584, ti=f687a000 task=f70fa400 task.ti=f687a000)
>> Mar 14 00:00:22 server1 kernel: [488470.189705] Stack:
>> Mar 14 00:00:22 server1 kernel: [488470.189721] Call Trace:
>> Mar 14 00:00:22 server1 kernel: [488470.189739] Code: 00 e8 ea e5 01 00
>> 83 c4 14 c3 8d b6 00 00 00 00 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24
>> 04 c7 04 24 30 ab 42 c1 e8 7c 11 1c 00 <0f> 0b eb fe 90 55 57 89 cf 56
>> 89 c6 b8 80 b0 52 c1 83 e6 07 53
>> Mar 14 00:00:22 server1 kernel: [488470.189739] EIP: [<c11a018b>]
>> assfail+0x1b/0x20 SS:ESP 0068:f687bf14
>>
>> Is this a bug related to AMD (CPU) or XFS?
>
> Hard to know without seeing the rest of the stack trace, is this all you got?
Yes, that was the only entry in the log file, I could not wake up the
monitor to get any more information.

>
> You hit an assertion failure in xfs.
>
> Are you running with CONFIG_XFS_DEBUG?
Nope.

CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set

>
> -Eric
>


