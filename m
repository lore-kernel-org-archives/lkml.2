Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2C0OPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:15:40 -0400
Received: from mail2.charite.de ([141.42.206.200]:44869 "EHLO mail2.charite.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab2C0OPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:15:38 -0400
Date: Tue, 27 Mar 2012 16:15:36 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: 3.3.0: "INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)"
Message-ID: <20120327141536.GP25457@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mar 23 11:54:00 mail kernel:
Mar 23 11:54:00 mail kernel: [347213.025005] INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
Mar 23 11:54:00 mail kernel: [347213.025005] Pid: 12654, comm: cleanup Not tainted 3.3.0 #1
Mar 23 11:54:00 mail kernel: [347213.025005] Call Trace:
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c1062ccb>] ? __rcu_pending+0x10a/0x311
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c106388d>] ? rcu_check_callbacks+0x9b/0xa1
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c102c434>] ? update_process_times+0x2a/0x53
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c104f206>] ? tick_sched_timer+0x4f/0x90
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c103a101>] ? __remove_hrtimer+0x25/0x79
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c103a2ff>] ? __run_hrtimer.isra.32+0x38/0xbe
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c103ad95>] ? hrtimer_interrupt+0xda/0x23d
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c1016493>] ? smp_apic_timer_interrupt+0x4c/0x81
Mar 23 11:54:00 mail kernel: [347213.025005]  [<c127b5d9>] ? apic_timer_interrupt+0x31/0x38

-- 
Ralf Hildebrandt                   Charite Universitätsmedizin Berlin
ralf.hildebrandt@charite.de        Campus Benjamin Franklin
http://www.charite.de              Hindenburgdamm 30, 12203 Berlin
Geschäftsbereich IT, Abt. Netzwerk fon: +49-30-450.570.155
