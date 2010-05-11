Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0EKPAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:00:13 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:44263 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab0EKPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=qgda0EiWjk0SMJxu0ddGTlIt6meIkZstfWznaax0OGZXWMm2QO/lb7eH84uy0vdXgt
         hObpkH8Qi9xo3FdZs5Zalvs9Tn8GO5NcsXP4Y1+dZZrBGBMBUFXez3HD1uv0C0Ry3JOa
         Zp1izrkmE5Vj5U354D6m0j1JW+2HuwuTG78OA=
MIME-Version: 1.0
Date: Tue, 11 May 2010 20:30:07 +0530
Message-ID: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
Subject: DRM Error on Acer Aspire One
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With latest git kernel, I am getting following DRM error and not
getting XWindows :

[   45.269075] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[   45.269111] ------------[ cut here ]------------
[   45.269139] WARNING: at mm/highmem.c:453 debug_kmap_atomic+0xa9/0x11e()
[   45.269150] Hardware name: Aspire one
[   45.269158] Modules linked in: nf_conntrack_ftp ath9k ath9k_common
battery ath9k_hw [last unloaded: scsi_wait_scan]
[   45.269198] Pid: 0, comm: swapper Not tainted 2.6.34-rc7-netbook #6
[   45.269208] Call Trace:
[   45.269231]  [<c1030ecb>] warn_slowpath_common+0x65/0x7c
[   45.269249]  [<c108ce5d>] ? debug_kmap_atomic+0xa9/0x11e
[   45.269267]  [<c1030eef>] warn_slowpath_null+0xd/0x10
[   45.269284]  [<c108ce5d>] debug_kmap_atomic+0xa9/0x11e
[   45.269304]  [<c10207c9>] kmap_atomic_prot+0x4d/0xb2
[   45.269321]  [<c102083c>] kmap_atomic+0xe/0x10
[   45.269341]  [<c11f7d64>] i915_error_object_create+0xea/0x14f
[   45.269359]  [<c11f8132>] i915_handle_error+0x369/0x868
[   45.269380]  [<c11f86d0>] i915_hangcheck_elapsed+0x9f/0xdf
[   45.269399]  [<c103ab6e>] run_timer_softirq+0x1c9/0x269
[   45.269417]  [<c11f8631>] ? i915_hangcheck_elapsed+0x0/0xdf
[   45.269435]  [<c1035b7b>] __do_softirq+0xc6/0x186
[   45.269451]  [<c1035c61>] do_softirq+0x26/0x2b
[   45.269466]  [<c1035dd2>] irq_exit+0x29/0x66
[   45.269484]  [<c101681f>] smp_apic_timer_interrupt+0x6e/0x7c
[   45.269504]  [<c141f826>] apic_timer_interrupt+0x2a/0x30
[   45.269524]  [<c104007b>] ? ftrace_raw_event_signal_generate+0x6d/0xd4
[   45.269542]  [<c11bed9d>] ? acpi_idle_enter_simple+0x13b/0x168
[   45.269563]  [<c12dd2b9>] cpuidle_idle_call+0x6b/0xda
[   45.269580]  [<c1001a3c>] cpu_idle+0x44/0x74
[   45.269598]  [<c141a041>] start_secondary+0x1b2/0x1b7
[   45.269612] ---[ end trace ce01d7ca0ae214f4 ]---
[   45.269631] ------------[ cut here ]------------
[   45.269647] WARNING: at mm/highmem.c:453 debug_kmap_atomic+0xa9/0x11e()
[   45.269657] Hardware name: Aspire one
[   45.269665] Modules linked in: nf_conntrack_ftp ath9k ath9k_common
battery ath9k_hw [last unloaded: scsi_wait_scan]
[   45.269700] Pid: 0, comm: swapper Tainted: G        W  2.6.34-rc7-netbook #6
[   45.269710] Call Trace:
[   45.269726]  [<c1030ecb>] warn_slowpath_common+0x65/0x7c
[   45.269743]  [<c108ce5d>] ? debug_kmap_atomic+0xa9/0x11e
[   45.269760]  [<c1030eef>] warn_slowpath_null+0xd/0x10
[   45.269777]  [<c108ce5d>] debug_kmap_atomic+0xa9/0x11e
[   45.269795]  [<c10207c9>] kmap_atomic_prot+0x4d/0xb2
[   45.269812]  [<c102083c>] kmap_atomic+0xe/0x10
[   45.269829]  [<c11f7d64>] i915_error_object_create+0xea/0x14f
[   45.269848]  [<c11f8132>] i915_handle_error+0x369/0x868
[   45.269868]  [<c11f86d0>] i915_hangcheck_elapsed+0x9f/0xdf
[   45.269885]  [<c103ab6e>] run_timer_softirq+0x1c9/0x269
[   45.269903]  [<c11f8631>] ? i915_hangcheck_elapsed+0x0/0xdf
[   45.269920]  [<c1035b7b>] __do_softirq+0xc6/0x186
[   45.269937]  [<c1035c61>] do_softirq+0x26/0x2b
[   45.269952]  [<c1035dd2>] irq_exit+0x29/0x66
[   45.269968]  [<c101681f>] smp_apic_timer_interrupt+0x6e/0x7c
[   45.269985]  [<c141f826>] apic_timer_interrupt+0x2a/0x30
[   45.270004]  [<c104007b>] ? ftrace_raw_event_signal_generate+0x6d/0xd4
[   45.270051]  [<c11bed9d>] ? acpi_idle_enter_simple+0x13b/0x168
[   45.270071]  [<c12dd2b9>] cpuidle_idle_call+0x6b/0xda
[   45.270087]  [<c1001a3c>] cpu_idle+0x44/0x74
[   45.270104]  [<c141a041>] start_secondary+0x1b2/0x1b7
[   45.270117] ---[ end trace ce01d7ca0ae214f5 ]---
[   45.270135] ------------[ cut here ]------------

dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634-rc7.txt
.config : http://userweb.kernel.org/~jaswinder/acer_netbook/config_2634-rc7.txt

How can I fix these errors.

Thanks,
--
Jaswinder Singh.
