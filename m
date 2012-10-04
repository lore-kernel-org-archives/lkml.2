Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957Ab2JDOSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:18:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53860 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab2JDOS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:18:29 -0400
MIME-Version: 1.0
Date: Thu, 4 Oct 2012 10:18:28 -0400
Message-ID: <CAHFgRy9vSEwBe34VffBWZgy6ik_O0_FHW+fwasnN643WQX8gCg@mail.gmail.com>
Subject: 3.6.0+ (GIT) -- WARNING: at drivers/gpu/drm/i915/intel_display.c:1271
 intel_disable_pipe+0xab/0x12e() -- plane B assertion failure, should be off
 on pipe B but is still active
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    4.266874] WARNING: at drivers/gpu/drm/i915/intel_display.c:1271
intel_disable_pipe+0xab/0x12e()
[    4.266877] Hardware name: UL50VT
[    4.266880] plane B assertion failure, should be off on pipe B but
is still active
[    4.266882] Modules linked in:
[    4.266888] Pid: 1, comm: swapper/0 Not tainted 3.6.0+ #27
[    4.266891] Call Trace:
[    4.266899]  [<ffffffff8102dd26>] warn_slowpath_common+0x7e/0x97
[    4.266905]  [<ffffffff8102ddd3>] warn_slowpath_fmt+0x41/0x43
[    4.266911]  [<ffffffff8129404c>] intel_disable_pipe+0xab/0x12e
[    4.266917]  [<ffffffff812945d9>] i9xx_crtc_disable+0xd1/0x144
[    4.266923]  [<ffffffff8129c112>] intel_modeset_setup_hw_state+0x438/0x69f
[    4.266929]  [<ffffffff8129c398>] intel_modeset_gem_init+0x1f/0x24
[    4.266936]  [<ffffffff8127bf37>] i915_driver_load+0xada/0xcde
[    4.266945]  [<ffffffff812628f0>] drm_get_pci_dev+0x16d/0x266
[    4.266951]  [<ffffffff8106bc63>] ? trace_hardirqs_on+0xd/0xf
[    4.266957]  [<ffffffff81454392>] i915_pci_probe+0x4d/0x57
[    4.266964]  [<ffffffff811e4844>] local_pci_probe+0x5b/0xa2
[    4.266969]  [<ffffffff811e494b>] pci_device_probe+0xc0/0xed
[    4.266976]  [<ffffffff8133bb44>] ? driver_probe_device+0x1b5/0x1b5
[    4.266981]  [<ffffffff8133ba29>] driver_probe_device+0x9a/0x1b5
[    4.266987]  [<ffffffff8133bb92>] __driver_attach+0x4e/0x6f
[    4.266992]  [<ffffffff8133a175>] bus_for_each_dev+0x52/0x84
[    4.266998]  [<ffffffff8133b542>] driver_attach+0x19/0x1b
[    4.267003]  [<ffffffff8133b1e3>] bus_add_driver+0xf4/0x219
[    4.267009]  [<ffffffff8133c0ef>] driver_register+0x8e/0x114
[    4.267014]  [<ffffffff811e3d09>] __pci_register_driver+0x5a/0x5f
[    4.267020]  [<ffffffff81262a6a>] drm_pci_init+0x81/0xe7
[    4.267027]  [<ffffffff81ac109d>] ? ttm_init+0x62/0x62
[    4.267033]  [<ffffffff81ac1103>] i915_init+0x66/0x68
[    4.267039]  [<ffffffff810001fa>] do_one_initcall+0x7a/0x130
[    4.267045]  [<ffffffff81a97c3f>] kernel_init+0x10b/0x18f
[    4.267051]  [<ffffffff81a9752f>] ? do_early_param+0x8c/0x8c
[    4.267058]  [<ffffffff81471334>] kernel_thread_helper+0x4/0x10
[    4.267065]  [<ffffffff8104f6a5>] ? finish_task_switch+0x38/0xb0
[    4.267070]  [<ffffffff81000c71>] ? __switch_to+0x19c/0x426
[    4.267076]  [<ffffffff8146b7a0>] ? retint_restore_args+0xe/0xe
[    4.267082]  [<ffffffff81a97b34>] ? start_kernel+0x3b3/0x3b3
[    4.267087]  [<ffffffff81471330>] ? gs_change+0xb/0xb
