Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HQNI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:08:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43276 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HQNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:08:55 -0400
Message-ID: <4E4BBD60.10306@gmail.com>
Date: Wed, 17 Aug 2011 15:08:48 +0200
From: =?UTF-8?B?VG9ycXVpbCBNYWNkb25hbGQgU8O4cmVuc2Vu?= 
	<torquil@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Boot kernel panic after upgrade 3.0.1 -> 3.0.2
References: <4E4B9903.4000203@gmail.com> <1313581478.24749.25.camel@x61.thuisdomein>
In-Reply-To: <1313581478.24749.25.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/11 13:44, Paul Bolle wrote:
> On Wed, 2011-08-17 at 12:33 +0200, Torquil Macdonald Sørensen wrote:
>> At boot time, I get the following message on screen (copied by hand, but I'm
>> hoping there are not too many mistakes...):
>>
>> Kernel panic, not syncing: VFS Unable to mount root fs on unknown block(0,0)
>> Pid: 1. comm: swapper  Not tainted 3.0.2 #1
>> Call Trace:
>>    [<fffffff8127e4a9>] ? panic 0xa4 0x19b
>>    [<fffffff813f1e56>] ? mount_block_root+0x236/0x254
>>    [<fffffff81002930>] ? do_bounds+0x57/0x65
>>    [<fffffff813f1ff6>] ? prepare_namespace+0x133/0x169
>>    [<fffffff813f1b7c>] ? kernel_init+0x105/0x10a
>>    [<fffffff81284a94>] ? kernel_thread_helper+0x4/0x10
>>    [<fffffff813f1a77>] ? start_kernel+0x341/341
>>    [<fffffff81284a90>] ? gs_change+0xb/0xb
>
> I tend to see messages like that when I've messed up some basic setting
> needed to boot a kernel.
>
> My first suggestion would be to check your kernel command line. Does it
> have a "root=" parameter? Another thing I'd check is the initramfs. Does
> the bootloader pass the kernel an initramfs? Is the initramfs a valid
> initramfs? Does the (valid) initramfs have the stuff the kernel needs
> (block modules, fs modules). Stuff like that ...

Thanks Paul! It seems that the Debian kernel building/installation system has 
not generated an initrd for me... That must be the problem.

I'll get that straightened out, and report back with success or failure. So this 
is most likely not a kernel issue.

Best regards
Torquil Sørensen
