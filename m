Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1LMOhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:37:19 -0500
Received: from mail2.charite.de ([141.42.206.200]:34330 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1LMOhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:37:16 -0500
Date: Tue, 13 Dec 2011 15:37:13 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at /build/buildd/linux-3.0.0/net/sched/sch_generic.c:255
  dev_watchdog+0x1e6/0x1f0()
Message-ID: <20111213143712.GQ15012@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dmesg:

[887648.909830] TCP: Peer 217.231.194.98:49156/993 unexpectedly shrunk window 3688313894:3688343052 (repaired)
[1108300.282636] ------------[ cut here ]------------
[1108300.284553] WARNING: at /build/buildd/linux-3.0.0/net/sched/sch_generic.c:255 dev_watchdog+0x1e6/0x1f0()
[1108300.284699] Hardware name: VMware Virtual Platform
[1108300.284736] NETDEV WATCHDOG: eth0 (vmxnet3): transmit queue 3 timed out
[1108300.284879] Modules linked in: xt_multiport iptable_filter ip_tables x_tables mptspi mptscsih mptbase vmw_balloon snd_pcsp
snd_pcm snd_timer snd serio_raw soundcore snd_page_alloc floppy vmw_pvscsi vmxnet3 [last unloaded: scsi_wait_scan]
[1108300.285619] Pid: 0, comm: kworker/0:1 Not tainted 3.0.0-13-virtual #22-Ubuntu
[1108300.285709] Call Trace:
[1108300.286407]  [<c01503c2>] warn_slowpath_common+0x72/0xa0
[1108300.286486]  [<c057e2a6>] ? dev_watchdog+0x1e6/0x1f0
[1108300.286494]  [<c057e2a6>] ? dev_watchdog+0x1e6/0x1f0
[1108300.286501]  [<c0150493>] warn_slowpath_fmt+0x33/0x40
[1108300.286507]  [<c057e2a6>] dev_watchdog+0x1e6/0x1f0
[1108300.286619]  [<c015d80f>] call_timer_fn+0x2f/0x110
[1108300.286626]  [<c057e0c0>] ? qdisc_reset+0x40/0x40
[1108300.286632]  [<c015ef0b>] run_timer_softirq+0xeb/0x210
[1108300.286638]  [<c057e0c0>] ? qdisc_reset+0x40/0x40
[1108300.286645]  [<c0156f10>] ? local_bh_enable_ip+0x90/0x90
[1108300.286652]  [<c0156f10>] ? local_bh_enable_ip+0x90/0x90
[1108300.286658]  [<c0156f91>] __do_softirq+0x81/0x1a0
[1108300.286664]  [<c0156f10>] ? local_bh_enable_ip+0x90/0x90
[1108300.286734]  <IRQ>  [<c01572d6>] ? irq_exit+0x76/0xa0
[1108300.286784]  [<c06623e9>] ? smp_apic_timer_interrupt+0x59/0x88
[1108300.286797]  [<c065b259>] ? apic_timer_interrupt+0x31/0x38
[1108300.286817]  [<c012cd6a>] ? native_safe_halt+0xa/0x10
[1108300.286834]  [<c0110d6c>] ? default_idle.part.5+0x3c/0xf0
[1108300.286841]  [<c0110e3f>] ? default_idle+0x1f/0x40
[1108300.286846]  [<c0108c7a>] ? cpu_idle+0x8a/0xc0
[1108300.286863]  [<c064035f>] ? start_secondary+0xe8/0xed
[1108300.286987] ---[ end trace 1bbd614812e11d30 ]---
[1108300.287126] eth0: tx hang
[1108300.302499] eth0: resetting
[1108300.446979] eth0: intr type 3, mode 0, 9 vectors allocated
[1108300.537085] eth0: NIC Link is Up 10000 Mbps

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
