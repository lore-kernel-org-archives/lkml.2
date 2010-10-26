Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512Ab0JZVsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:48:16 -0400
Received: from mail.candelatech.com ([208.74.158.172]:42835 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab0JZVsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:48:15 -0400
Message-ID: <4CC74C9F.6040801@candelatech.com>
Date: Tue, 26 Oct 2010 14:48:15 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: lockdep:  Invalid subclass: 31, related to mousedev_create
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is coming out of today's wireless-testing tree:

BUG: looking up invalid subclass: 31
turning off the locking correctness validator.
Pid: 1, comm: swapper Not tainted 2.6.36-wl+ #33
Call Trace:
  [<c076af55>] ? printk+0xf/0x12
  [<c045535f>] look_up_lock_class+0x2d/0x9e
  [<c0455bb7>] register_lock_class+0x17/0x2ac
  [<c0455ed2>] ? lockdep_init_map+0x86/0xf1
  [<c0454fbe>] ? debug_mutex_init+0x28/0x33
  [<c0455f2c>] lockdep_init_map+0xe0/0xf1
  [<c0686d0d>] mousedev_create+0x8d/0x196
  [<c09b4215>] mousedev_init+0x15/0x51
  [<c040115e>] do_one_initcall+0x71/0x121
  [<c09b4200>] ? mousedev_init+0x0/0x51
  [<c098838c>] kernel_init+0x126/0x1a7
  [<c0988266>] ? kernel_init+0x0/0x1a7
  [<c0403586>] kernel_thread_helper+0x6/0x1a
mice: PS/2 mouse device common for all mice

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

