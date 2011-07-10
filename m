Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1GJPKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:10:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59496 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1GJPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:10:28 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: i915_gem_inactive_shrink fault
Date: Sun, 10 Jul 2011 17:10:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: Keith Packard <keithp@keithp.com>, lkml <linux-kernel@vger.kernel.org>
References: <1309856364.18875.110.camel@minggr.sh.intel.com>
In-Reply-To: <1309856364.18875.110.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101710.23262.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 5 lipca 2011 o 10:59:24 Lin Ming wrote:
> It seems i915 driver loads fail.
> 
> mlin@wsm:~$ dmesg |grep -i i915
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
> i915 0000:00:02.0: irq 47 for MSI/MSI-X
> WARNING: at /linux-2.6/drivers/gpu/drm/i915/intel_display.c:826
> assert_fdi_tx+0xcc/0xd8() [<ffffffff8133d865>]
> i915_driver_load+0xb12/0x10e9
>  [<ffffffff816a891a>] i915_pci_probe+0x1b/0x1d
>  [<ffffffff81d12264>] i915_init+0x8b/0x8d
> WARNING: at /linux-2.6/drivers/gpu/drm/i915/intel_display.c:826
> assert_fdi_tx+0xcc/0xd8() [<ffffffff8133d865>]
> i915_driver_load+0xb12/0x10e9
>  [<ffffffff816a891a>] i915_pci_probe+0x1b/0x1d
>  [<ffffffff81d12264>] i915_init+0x8b/0x8d
> [drm:i915_driver_load] *ERROR* failed to init modeset
> i915 0000:00:02.0: PCI INT A disabled
> i915: probe of 0000:00:02.0 failed with error -5
>  [<ffffffff81355191>] i915_gem_inactive_shrink+0x2b/0x18d
> 
> 
> The fault message as below.
> See the attachments for full dmesg, kernel config and lspci output.
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> IP: [<ffffffff816d4422>] mutex_trylock+0x61/0x131
> PGD 133cd5067 PUD 134301067 PMD 0
> Oops: 0002 [#1] SMP
> CPU 3
> Modules linked in:
> 
> Pid: 2322, comm: bash Tainted: G        W   3.0.0-rc6-tip-mlin+ #571 Intel

Older kernels work fine?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
