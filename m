Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0IHNxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:53:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33049 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0IHNxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:53:17 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [regression] *ERROR* timed out waiting for FORCE_DETECT in 36rc3 on i915
Date: Wed, 08 Sep 2010 15:53:16 +0200
Message-ID: <87mxrswddf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of my test box with Intel graphics spews out a lot of 

[drm:intel_crt_detect_hotplug] *ERROR* timed out waiting for FORCE_DETECT to go off

messages after boot now. This didn't show in 2.6.35, so it seems
like a regression. The system just runs in VGA text mode
(but with KMS) without X.

-Andi

Hardware information

[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to userspace modesetting.
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 42 on node -1
  alloc kstat_irqs on node -1
i915 0000:00:02.0: irq 42 for MSI/MSI-X
[drm] set up 7M of stolen space
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[drm] initialized overlay support
Console: switching to colour frame buffer device 128x48
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
No ACPI video bus found
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

00:02.0 VGA compatible controller: Intel Corporation: Unknown device 29c2 (rev 02)

-- 
ak@linux.intel.com -- Speaking for myself only.
