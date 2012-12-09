Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2LIB1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 20:27:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab2LIB1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 20:27:32 -0500
Date: Sat, 8 Dec 2012 20:27:24 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, alexander.deucher@amd.com
Subject: rs600 warn on while booting 3.7-rc8
Message-ID: <20121209012724.GA18395@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	David Airlie <airlied@linux.ie>, alexander.deucher@amd.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   66.104790] WARNING: at drivers/gpu/drm/radeon/rs600.c:571 rs600_irq_set+0x1e2/0x200()
[   66.105748] Hardware name: GA-MA78GM-S2H
[   66.106220] Can't enable IRQ/MSI because no handler is installed
[   66.106935] Modules linked in:
[   66.107329] Pid: 43, comm: kworker/0:1 Not tainted 3.7.0-rc8+ #8
[   66.108044] Call Trace:
[   66.108350]  [<ffffffff8104da4f>] warn_slowpath_common+0x7f/0xc0
[   66.109067]  [<ffffffff8104db46>] warn_slowpath_fmt+0x46/0x50
[   66.109749]  [<ffffffff81480762>] rs600_irq_set+0x1e2/0x200
[   66.110416]  [<ffffffff8146fa92>] ? radeon_irq_kms_enable_hpd+0x32/0x90
[   66.111203]  [<ffffffff8146faca>] radeon_irq_kms_enable_hpd+0x6a/0x90
[   66.111965]  [<ffffffff81480123>] rs600_hpd_init+0xb3/0xc0
[   66.112627]  [<ffffffff814680f3>] radeon_modeset_init+0x323/0xb90
[   66.113355]  [<ffffffff81444f40>] radeon_driver_load_kms+0xf0/0x180
[   66.114103]  [<ffffffff8140f356>] drm_get_pci_dev+0x186/0x2c0
[   66.114790]  [<ffffffff8119dda8>] ? kfree+0x298/0x2a0
[   66.115397]  [<ffffffff8171e22a>] radeon_pci_probe+0xb1/0xb9
[   66.116074]  [<ffffffff81357679>] local_pci_probe+0x79/0x100
[   66.116751]  [<ffffffff8106db18>] work_for_cpu_fn+0x18/0x30
[   66.117418]  [<ffffffff810711c7>] process_one_work+0x207/0x750
[   66.118109]  [<ffffffff81071157>] ? process_one_work+0x197/0x750
[   66.118825]  [<ffffffff8106db00>] ? too_many_workers+0x40/0x40
[   66.119517]  [<ffffffff8107173c>] process_scheduled_works+0x2c/0x40
[   66.120259]  [<ffffffff81071c82>] worker_thread+0x2f2/0x440
[   66.120925]  [<ffffffff81071990>] ? rescuer_thread+0x240/0x240
[   66.121622]  [<ffffffff8107844d>] kthread+0xed/0x100
[   66.122218]  [<ffffffff810b7f1e>] ? put_lock_stats.isra.23+0xe/0x40
[   66.122961]  [<ffffffff81078360>] ? kthread_create_on_node+0x160/0x160
[   66.123739]  [<ffffffff81742e1c>] ret_from_fork+0x7c/0xb0
[   66.124384]  [<ffffffff81078360>] ? kthread_create_on_node+0x160/0x160

