Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083Ab2FHKVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:21:25 -0400
Received: from mail.profihost.ag ([85.158.179.208]:42192 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2FHKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:21:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2012 06:21:22 EDT
Message-ID: <4FD1D090.2060904@profihost.ag>
Date: Fri, 08 Jun 2012 12:14:40 +0200
From: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Reply-To: p.herz@profihost.ag
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: stalled CPUs after upgrading to 3.0.28
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by p.herz@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading linux kernel to version 3.0.28 some systems randomly 
freeze, because of "rcu_sched_state" stalling CPU(s).

Is there anything known to this problem? How can it be fixed?

Thanks and regards,
Philipp

+------------------------------------------------------------------+
    INFO: rcu_sched_state detected stall on CPU 3 (t=6361556 jiffies)
    sending NMI to all CPUs:
    NMI backtrace for cpu 2
    CPU 2
    Modules linked in: xt_tcpudp coretemp k8temp ipt_REJECT 
iptable_filter ip_tables x_tables ipv6 i2c_i801 i2c_core [last unloaded: 
scsi_wait_scan]
    Pid: 24170, comm: httpd Not tainted 2.6.40.28p4 #1 FUJITSU SIEMENS 
D2581-A5 /D2581-A5
    RIP: 0010:[<ffffffff815c45a9>] [<ffffffff815c45a9>] 
_raw_spin_lock+0x19/0x20
    RSP: 0018:ffff8801153e5dd8 EFLAGS: 00000293
    RAX: 000000000000056d RBX: ffff88010d2846d0 RCX: 0000000000000000
    RDX: 000000000000056a RSI: 0000000000000003 RDI: ffff88010d2846d0
    RBP: ffff8801153e5dd8 R08: ffff8801153e5e58 R09: dead000000100100
    R10: 0000000000000000 R11: ffffea0003e2eb28 R12: ffff8801153e5e58
    R13: ffff8801153e5e70 R14: ffff880012855348 R15: ffff8801153e5e58
    FS: 00007f1ea2c2a740(0000) GS:ffff88013fd00000(0000) 
knlGS:0000000000000000
    CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007f1ea00ee7e5 CR3: 0000000133ed7000 CR4: 00000000000006e0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process httpd (pid: 24170, threadinfo ffff8801153e4000, task 
ffff880132180000)Stack:
    ffff8801153e5df8 ffffffff8129a0f4 ffff8801153e5e18 0000000000c30003
    ffff8801153e5e18 ffffffff8129a120 ffff8801153e5e18 ffff88013b2e4060
    ffff8801153e5ea8 ffffffff8129c942 ffff8801395b1a40 ffff880100c30003
