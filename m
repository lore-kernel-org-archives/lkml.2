Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab1J1MXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:23:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34532 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1J1MW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:22:57 -0400
Date: Fri, 28 Oct 2011 20:22:35 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [Known BUG?] i915 hang on 3.0.0-12 (Ubuntu 11.10 release)
Message-ID: <20111028122235.GA5593@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

Just got below error on Ubuntu-11.10 (kernel: 3.0.0-12-generic),
and after that my screen can't show normally.
No sure if it's a known issue.

[169509.080020] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[169509.080026] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[169509.080604] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 1640573 at 1640569, next 1640574)
[169509.080688] [drm:i915_reset] *ERROR* Failed to reset chip.

BTW, dmesg and i915_error_state and lspci is attached.

Thanks,
Yong


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="gnu_hung.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-12-generic (buildd@vernadsky) (gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3) ) #20-Ubuntu SMP Fri Oct 7 14:50:42 UTC 2011 (Ubuntu 3.0.0-12.20-generic 3.0.4)
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007d3ff800 (usable)
[    0.000000]  BIOS-e820: 000000007d3ff800 - 000000007d453c00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007d453c00 - 000000007d455c00 (ACPI data)
[    0.000000]  BIOS-e820: 000000007d455c00 - 000000007e000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled in hardware: non-PAE kernel!
[    0.000000] NX (Execute Disable) protection: approximated by x86 segment limits
[    0.000000] DMI 2.5 present.
[    0.000000] DMI: Dell Inc. OptiPlex 755                 /0Y255C, BIOS A11 08/04/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7d3ff max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 000000000 write-back
[    0.000000]   1 base 07D600000 mask FFFE00000 uncachable
[    0.000000]   2 base 07D800000 mask FFF800000 uncachable
[    0.000000]   3 base 07E000000 mask FFE000000 uncachable
[    0.000000]   4 base 07D500000 mask FFFF00000 uncachable
[    0.000000]   5 base 080000000 mask F80000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 64GB, type WB
[    0.000000] reg 1, base: 2006MB, range: 2MB, type UC
[    0.000000] reg 2, base: 2008MB, range: 8MB, type UC
[    0.000000] reg 3, base: 2016MB, range: 32MB, type UC
[    0.000000] reg 4, base: 2005MB, range: 1MB, type UC
[    0.000000] reg 5, base: 2GB, range: 2GB, type UC
[    0.000000] total RAM covered: 63445M
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 64K 	chunk_size: 128K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 64K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 64K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 61439M
[    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 64K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 64K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 128K 	chunk_size: 128K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 128K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 128K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 128K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 128K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 61439M
[    0.000000]  gran_size: 128K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 128K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 128K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 128K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 128K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 128K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 128K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 128K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 128K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 128K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 256K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 256K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 256K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 256K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 61439M
[    0.000000]  gran_size: 256K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 256K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 256K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 256K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 256K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 256K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 256K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 256K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 256K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 256K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 512K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 512K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 512K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 61439M
[    0.000000]  gran_size: 512K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 512K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 512K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 512K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 512K 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 512K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 512K 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 512K 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 512K 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 512K 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 1M 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 60G
[    0.000000]  gran_size: 1M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 61439M
[    0.000000]  gran_size: 1M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 1M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61438M
[    0.000000]  gran_size: 1M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 1M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61432M
[    0.000000]  gran_size: 1M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 1M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 1M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 1M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 1M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 1M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 32G
[    0.000000]  gran_size: 2M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 57345M
[    0.000000]  gran_size: 2M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 57345M
[    0.000000]  gran_size: 2M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61441M
[    0.000000]  gran_size: 2M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61441M
[    0.000000]  gran_size: 2M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61441M
[    0.000000]  gran_size: 2M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 2M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 2M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 2M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 2M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 2M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 4M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 57345M
[    0.000000]  gran_size: 4M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 61441M
[    0.000000]  gran_size: 4M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 61441M
[    0.000000]  gran_size: 4M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 61441M
[    0.000000]  gran_size: 4M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 4M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 4M 	chunk_size: 256M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 4M 	chunk_size: 512M 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 4M 	chunk_size: 1G 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 4M 	chunk_size: 2G 	num_reg: 8  	lose cover RAM: 1M
[    0.000000]  gran_size: 8M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 49157M
[    0.000000]  gran_size: 8M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 49157M
[    0.000000]  gran_size: 8M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 57349M
[    0.000000]  gran_size: 8M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 8M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 8M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 8M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 8M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 8M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 16M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 49157M
[    0.000000]  gran_size: 16M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 57349M
[    0.000000]  gran_size: 16M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 16M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 16M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 16M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 16M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 16M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 5M
[    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 32789M
[    0.000000]  gran_size: 32M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32789M
[    0.000000]  gran_size: 32M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 32M 	chunk_size: 256M 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 32M 	chunk_size: 512M 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 32M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 32M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 64M 	chunk_size: 64M 	num_reg: 8  	lose cover RAM: 32789M
[    0.000000]  gran_size: 64M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 64M 	chunk_size: 256M 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 64M 	chunk_size: 512M 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 64M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 64M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 21M
[    0.000000]  gran_size: 128M 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 85M
[    0.000000]  gran_size: 128M 	chunk_size: 256M 	num_reg: 6  	lose cover RAM: 85M
[    0.000000]  gran_size: 128M 	chunk_size: 512M 	num_reg: 6  	lose cover RAM: 85M
[    0.000000]  gran_size: 128M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 85M
[    0.000000]  gran_size: 128M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 85M
[    0.000000]  gran_size: 256M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 213M
[    0.000000]  gran_size: 256M 	chunk_size: 512M 	num_reg: 6  	lose cover RAM: 213M
[    0.000000]  gran_size: 256M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 213M
[    0.000000]  gran_size: 256M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 213M
[    0.000000]  gran_size: 512M 	chunk_size: 512M 	num_reg: 6  	lose cover RAM: 469M
[    0.000000]  gran_size: 512M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 469M
[    0.000000]  gran_size: 512M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 469M
[    0.000000]  gran_size: 1G 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 981M
[    0.000000]  gran_size: 1G 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 981M
[    0.000000]  gran_size: 2G 	chunk_size: 2G 	num_reg: 4  	lose cover RAM: 2005M
[    0.000000] mtrr_cleanup: can not find optimal value
[    0.000000] please specify mtrr_gran_size/mtrr_chunk_size
[    0.000000] e820 update range: 000000007d500000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00fe710] fe710
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] RAMDISK: 365fa000 - 372f5000
[    0.000000] ACPI: RSDP 000fec00 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 000fc5b3 0008C (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 000fc6e3 000F4 (v03 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DSDT fff76bf6 04596 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 7d3ff800 00040
[    0.000000] ACPI: SSDT fff7b2ab 000AA (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 000fc7d7 00092 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 000fc869 00028 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 000fc891 00096 (v32 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 000fc927 0003E (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 000fc965 00038 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 000fcbc1 00032 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DMAR 000fcbf3 00118 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 000fc99d 00176 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SSDT 7d3ff840 001B7 (v01 DpgPmm  Cpu0Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 7d3ffc49 001B7 (v01 DpgPmm  Cpu1Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 7d400052 00140 (v01 DpgPmm    CpuPm 00000010 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1116MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007d3ff
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007d3ff
[    0.000000] On node 0 totalpages: 512909
[    0.000000] free_area_init_node: node 0, pgdat c17b11c0, node_mem_map f5652200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2233 pages used for memmap
[    0.000000]   HighMem zone: 283464 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 6 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 7e000000 (gap: 7e000000:62000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5000000 s26240 r0 d22912 u524288
[    0.000000] pcpu-alloc: s26240 r0 d22912 u524288 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 508900
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.0.0-12-generic root=UUID=d312b08c-a3cf-45b8-8a74-3d91c33fed78 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 8208112 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0007d3ff)
[    0.000000] Memory: 2003528k/2052092k available (5329k kernel code, 48108k reserved, 2589k data, 696k init, 1142788k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc17bc000 - 0xc186a000   ( 696 kB)
[    0.000000]       .data : 0xc1534784 - 0xc17bbd80   (2589 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1534784   (5329 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:744 16
[    0.000000] CPU 0 irqstacks, hard=f440a000 soft=f440c000
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2659.859 MHz processor.
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5319.71 BogoMIPS (lpj=10639436)
[    0.004008] pid_max: default: 32768 minimum: 301
[    0.004027] Security Framework initialized
[    0.004040] AppArmor: AppArmor initialized
[    0.004042] Yama: becoming mindful.
[    0.004090] Mount-cache hash table entries: 512
[    0.004217] Initializing cgroup subsys cpuacct
[    0.004223] Initializing cgroup subsys memory
[    0.004229] Initializing cgroup subsys devices
[    0.004231] Initializing cgroup subsys freezer
[    0.004233] Initializing cgroup subsys net_cls
[    0.004235] Initializing cgroup subsys blkio
[    0.004240] Initializing cgroup subsys perf_event
[    0.004269] CPU: Physical Processor ID: 0
[    0.004271] CPU: Processor Core ID: 0
[    0.004274] mce: CPU supports 6 MCE banks
[    0.004282] CPU0: Thermal monitoring enabled (TM2)
[    0.004285] using mwait in idle threads.
[    0.008263] ACPI: Core revision 20110413
[    0.135192] ftrace: allocating 24885 entries in 49 pages
[    0.136052] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.136351] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.179812] CPU0: Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz stepping 0b
[    0.180010] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.180010] PEBS disabled due to CPU errata.
[    0.180010] ... version:                2
[    0.180010] ... bit width:              40
[    0.180010] ... generic registers:      2
[    0.180010] ... value mask:             000000ffffffffff
[    0.180010] ... max period:             000000007fffffff
[    0.180010] ... fixed-purpose events:   3
[    0.180010] ... event mask:             0000000700000003
[    0.180010] CPU 1 irqstacks, hard=f44b8000 soft=f44ba000
[    0.180010] Booting Node   0, Processors  #1
[    0.180010] smpboot cpu 1: start_ip = 9a000
[    0.008000] Initializing CPU#1
[    0.268028] Brought up 2 CPUs
[    0.268031] Total of 2 processors activated (10639.63 BogoMIPS).
[    0.269149] devtmpfs: initialized
[    0.269149] PM: Registering ACPI NVS region at 7d3ff800 (345088 bytes)
[    0.269638] print_constraints: dummy: 
[    0.269660] Time:  8:44:52  Date: 10/26/11
[    0.269697] NET: Registered protocol family 16
[    0.269722] Trying to unpack rootfs image as initramfs...
[    0.269806] EISA bus registered
[    0.269813] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.269816] ACPI: bus type pci registered
[    0.269869] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.269871] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.269873] PCI: Using MMCONFIG for extended config space
[    0.269875] PCI: Using configuration type 1 for base access
[    0.272131] bio: create slab <bio-0> at 0
[    0.272984] ACPI: EC: Look up EC in DSDT
[    0.323311] ACPI Warning: Incorrect checksum in table [TCPA] - 0x00, should be 0x87 (20110413/tbutils-314)
[    0.324355] ACPI: Interpreter enabled
[    0.324359] ACPI: (supports S0 S1 S3 S4 S5)
[    0.324380] ACPI: Using IOAPIC for interrupt routing
[    0.436231] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.436234] HEST: Table not found.
[    0.436239] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.472067] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.552064] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.552067] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.552069] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.552071] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.552073] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.552076] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfec00000]
[    0.552078] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xdfffffff]
[    0.552080] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.552082] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.552084] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.552086] pci_root PNP0A03:00: host bridge window [mem 0xfedad800-0xfedadfff]
[    0.552103] pci 0000:00:00.0: [8086:29b0] type 0 class 0x000600
[    0.552142] pci 0000:00:01.0: [8086:29b1] type 1 class 0x000604
[    0.552170] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.552173] pci 0000:00:01.0: PME# disabled
[    0.552187] pci 0000:00:02.0: [8086:29b2] type 0 class 0x000300
[    0.552196] pci 0000:00:02.0: reg 10: [mem 0xfea00000-0xfea7ffff]
[    0.552201] pci 0000:00:02.0: reg 14: [io  0xec90-0xec97]
[    0.552206] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.552211] pci 0000:00:02.0: reg 1c: [mem 0xfeb00000-0xfebfffff]
[    0.552239] pci 0000:00:02.1: [8086:29b3] type 0 class 0x000380
[    0.552247] pci 0000:00:02.1: reg 10: [mem 0xfea80000-0xfeafffff]
[    0.552290] pci 0000:00:03.0: [8086:29b4] type 0 class 0x000780
[    0.552301] pci 0000:00:03.0: reg 10: [mem 0xfedad000-0xfedad00f 64bit]
[    0.552331] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.552333] pci 0000:00:03.0: PME# disabled
[    0.552345] pci 0000:00:03.2: [8086:29b6] type 0 class 0x000101
[    0.552355] pci 0000:00:03.2: reg 10: [io  0xfe80-0xfe87]
[    0.552360] pci 0000:00:03.2: reg 14: [io  0xfe90-0xfe93]
[    0.552365] pci 0000:00:03.2: reg 18: [io  0xfea0-0xfea7]
[    0.552370] pci 0000:00:03.2: reg 1c: [io  0xfeb0-0xfeb3]
[    0.552376] pci 0000:00:03.2: reg 20: [io  0xfef0-0xfeff]
[    0.552404] pci 0000:00:03.3: [8086:29b7] type 0 class 0x000700
[    0.552414] pci 0000:00:03.3: reg 10: [io  0xec98-0xec9f]
[    0.552419] pci 0000:00:03.3: reg 14: [mem 0xfe9da000-0xfe9dafff]
[    0.552483] pci 0000:00:19.0: [8086:10bd] type 0 class 0x000200
[    0.552499] pci 0000:00:19.0: reg 10: [mem 0xfe9e0000-0xfe9fffff]
[    0.552507] pci 0000:00:19.0: reg 14: [mem 0xfe9db000-0xfe9dbfff]
[    0.552515] pci 0000:00:19.0: reg 18: [io  0xecc0-0xecdf]
[    0.552559] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.552562] pci 0000:00:19.0: PME# disabled
[    0.552581] pci 0000:00:1a.0: [8086:2937] type 0 class 0x000c03
[    0.552619] pci 0000:00:1a.0: reg 20: [io  0xff20-0xff3f]
[    0.552658] pci 0000:00:1a.1: [8086:2938] type 0 class 0x000c03
[    0.552696] pci 0000:00:1a.1: reg 20: [io  0xff00-0xff1f]
[    0.552744] pci 0000:00:1a.7: [8086:293c] type 0 class 0x000c03
[    0.552764] pci 0000:00:1a.7: reg 10: [mem 0xfe9d9c00-0xfe9d9fff]
[    0.552830] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.552834] pci 0000:00:1a.7: PME# disabled
[    0.552860] pci 0000:00:1b.0: [8086:293e] type 0 class 0x000403
[    0.552874] pci 0000:00:1b.0: reg 10: [mem 0xfe9dc000-0xfe9dffff 64bit]
[    0.552922] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.552926] pci 0000:00:1b.0: PME# disabled
[    0.552943] pci 0000:00:1c.0: [8086:2940] type 1 class 0x000604
[    0.552992] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.552995] pci 0000:00:1c.0: PME# disabled
[    0.553020] pci 0000:00:1d.0: [8086:2934] type 0 class 0x000c03
[    0.553058] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.553097] pci 0000:00:1d.1: [8086:2935] type 0 class 0x000c03
[    0.553137] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.553176] pci 0000:00:1d.2: [8086:2936] type 0 class 0x000c03
[    0.553214] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.553262] pci 0000:00:1d.7: [8086:293a] type 0 class 0x000c03
[    0.553281] pci 0000:00:1d.7: reg 10: [mem 0xff980800-0xff980bff]
[    0.553347] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.553351] pci 0000:00:1d.7: PME# disabled
[    0.553368] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    0.553418] pci 0000:00:1f.0: [8086:2914] type 0 class 0x000601
[    0.553494] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.553497] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.553534] pci 0000:00:1f.2: [8086:2922] type 0 class 0x000106
[    0.553550] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.553557] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.553565] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.553572] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.553579] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfedf]
[    0.553586] pci 0000:00:1f.2: reg 24: [mem 0xff970000-0xff9707ff]
[    0.553616] pci 0000:00:1f.2: PME# supported from D3hot
[    0.553619] pci 0000:00:1f.2: PME# disabled
[    0.553634] pci 0000:00:1f.3: [8086:2930] type 0 class 0x000c05
[    0.553647] pci 0000:00:1f.3: reg 10: [mem 0xfe9d9b00-0xfe9d9bff 64bit]
[    0.553668] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    0.553713] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.553716] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.553719] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.553723] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.553759] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.553763] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.553766] pci 0000:00:1c.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.553771] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.553826] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.553830] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.553834] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.553839] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.553841] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.553844] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.553846] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.553848] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.553850] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.553852] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfec00000] (subtractive decode)
[    0.553855] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.553857] pci 0000:00:1e.0:   bridge window [mem 0xff980800-0xff980bff] (subtractive decode)
[    0.553859] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.553861] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.553863] pci 0000:00:1e.0:   bridge window [mem 0xfedad800-0xfedadfff] (subtractive decode)
[    0.553875] pci_bus 0000:00: on NUMA node 0
[    0.553881] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.554437] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.554843] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.555186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.555549]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.555551]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.555553] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.581132] Freeing initrd memory: 13292k freed
[    1.869721] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    1.870487] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.871239] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    1.871990] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.872763] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    1.873515] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    1.874266] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.875024] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.875301] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.875312] vgaarb: loaded
[    1.875313] vgaarb: bridge control possible 0000:00:02.0
[    1.875516] SCSI subsystem initialized
[    1.875528] libata version 3.00 loaded.
[    1.875528] usbcore: registered new interface driver usbfs
[    1.875528] usbcore: registered new interface driver hub
[    1.875528] usbcore: registered new device driver usb
[    1.875528] PCI: Using ACPI for IRQ routing
[    1.880969] PCI: pci_cache_line_size set to 64 bytes
[    1.880983] pci 0000:00:03.0: no compatible bridge window for [mem 0xfedad000-0xfedad00f 64bit]
[    1.881011] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
[    1.881043] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.881046] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.881048] reserve RAM buffer: 000000007d3ff800 - 000000007fffffff 
[    1.881151] NetLabel: Initializing
[    1.881152] NetLabel:  domain hash size = 128
[    1.881153] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.881163] NetLabel:  unlabeled traffic allowed by default
[    1.881197] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.881201] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.881206] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.884137] Switching to clocksource hpet
[    1.888034] Switched to NOHz mode on CPU #0
[    1.888070] Switched to NOHz mode on CPU #1
[    1.890598] AppArmor: AppArmor Filesystem Enabled
[    1.890621] pnp: PnP ACPI init
[    1.890638] ACPI: bus type pnp registered
[    1.898536] pnp 00:00: [bus 00-ff]
[    1.898538] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.898541] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.898542] pnp 00:00: [io  0x0d00-0xffff window]
[    1.898544] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.898546] pnp 00:00: [mem 0x000c0000-0x000effff window]
[    1.898548] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.898550] pnp 00:00: [mem 0xf0000000-0xfec00000 window]
[    1.898552] pnp 00:00: [mem 0x80000000-0xdfffffff window]
[    1.898555] pnp 00:00: [mem 0xf0000000-0xefffffff window disabled]
[    1.898557] pnp 00:00: [mem 0xff980800-0xff980bff window]
[    1.898559] pnp 00:00: [mem 0xff97c000-0xff97ffff window]
[    1.898560] pnp 00:00: [mem 0xfed20000-0xfed9ffff window]
[    1.898562] pnp 00:00: [mem 0xfedad800-0xfedadfff window]
[    1.898605] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.903387] pnp 00:01: [io  0x0060]
[    1.903389] pnp 00:01: [io  0x0064]
[    1.903390] pnp 00:01: [io  0x0062-0x0063]
[    1.903392] pnp 00:01: [io  0x0065-0x006f]
[    1.903394] pnp 00:01: [io  0x00e0-0x00ef]
[    1.903395] pnp 00:01: [io  0x0800-0x085f]
[    1.903397] pnp 00:01: [io  0x0c00-0x0c7f]
[    1.903399] pnp 00:01: [io  0x0860-0x08ff]
[    1.903448] system 00:01: [io  0x0800-0x085f] has been reserved
[    1.903450] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    1.903453] system 00:01: [io  0x0860-0x08ff] has been reserved
[    1.903456] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.903731] pnp 00:02: [io  0x0080-0x009f]
[    1.903733] pnp 00:02: [io  0x0000-0x001f]
[    1.903734] pnp 00:02: [io  0x00c0-0x00df]
[    1.903737] pnp 00:02: [dma 4]
[    1.903760] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.903968] pnp 00:03: [io  0x00f0-0x00ff]
[    1.903978] pnp 00:03: [irq 13]
[    1.904017] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.904215] pnp 00:04: [io  0x0061]
[    1.904238] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.904442] pnp 00:05: [io  0x0070-0x007f]
[    1.904447] pnp 00:05: [irq 8]
[    1.904473] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.913546] pnp 00:06: [io  0x03f0-0x03f5]
[    1.913549] pnp 00:06: [io  0x03f7]
[    1.913553] pnp 00:06: [irq 6]
[    1.913555] pnp 00:06: [dma 2]
[    1.914051] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.928465] pnp 00:07: [io  0x0378-0x037f]
[    1.928467] pnp 00:07: [io  0x0778-0x077f]
[    1.928471] pnp 00:07: [irq 7]
[    1.928473] pnp 00:07: [dma 0 disabled]
[    1.929648] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.935220] pnp 00:08: [io  0x03f8-0x03ff]
[    1.935225] pnp 00:08: [irq 4]
[    1.935618] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.954039] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    1.954070] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.954076] pnp: PnP ACPI: found 10 devices
[    1.954077] ACPI: ACPI bus type pnp unregistered
[    1.954080] PnPBIOS: Disabled by ACPI PNP
[    1.989913] PCI: max bus depth: 1 pci_try_num: 2
[    1.989936] pci 0000:00:1f.2: BAR 5: assigned [mem 0xf0000000-0xf00007ff]
[    1.989941] pci 0000:00:1f.2: BAR 5: set to [mem 0xf0000000-0xf00007ff] (PCI address [0xf0000000-0xf00007ff])
[    1.989945] pci 0000:00:03.0: BAR 0: assigned [mem 0xf0000800-0xf000080f 64bit]
[    1.989949] pci 0000:00:03.0: BAR 0: set to [mem 0xf0000800-0xf000080f 64bit] (PCI address [0xf0000800-0xf000080f])
[    1.989953] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0100000-0xf02fffff 64bit pref]
[    1.989956] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    1.989958] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.989960] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.989963] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    1.989966] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.989969] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.989972] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.989976] pci 0000:00:1c.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    1.989980] pci 0000:00:1c.0:   bridge window [mem 0xf0100000-0xf02fffff 64bit pref]
[    1.989985] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    1.989987] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.989991] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.989994] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.990008] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.990013] pci 0000:00:01.0: setting latency timer to 64
[    1.990018] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.990021] pci 0000:00:1c.0: setting latency timer to 64
[    1.990027] pci 0000:00:1e.0: setting latency timer to 64
[    1.990030] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.990032] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.990034] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.990037] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    1.990039] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    1.990041] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfec00000]
[    1.990043] pci_bus 0000:00: resource 10 [mem 0x80000000-0xdfffffff]
[    1.990045] pci_bus 0000:00: resource 11 [mem 0xff980800-0xff980bff]
[    1.990047] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    1.990049] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    1.990051] pci_bus 0000:00: resource 14 [mem 0xfedad800-0xfedadfff]
[    1.990053] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe8fffff]
[    1.990055] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    1.990057] pci_bus 0000:02: resource 1 [mem 0xfe700000-0xfe7fffff]
[    1.990059] pci_bus 0000:02: resource 2 [mem 0xf0100000-0xf02fffff 64bit pref]
[    1.990061] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    1.990063] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    1.990065] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    1.990067] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000effff]
[    1.990069] pci_bus 0000:03: resource 8 [mem 0x000f0000-0x000fffff]
[    1.990071] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfec00000]
[    1.990073] pci_bus 0000:03: resource 10 [mem 0x80000000-0xdfffffff]
[    1.990075] pci_bus 0000:03: resource 11 [mem 0xff980800-0xff980bff]
[    1.990077] pci_bus 0000:03: resource 12 [mem 0xff97c000-0xff97ffff]
[    1.990079] pci_bus 0000:03: resource 13 [mem 0xfed20000-0xfed9ffff]
[    1.990081] pci_bus 0000:03: resource 14 [mem 0xfedad800-0xfedadfff]
[    1.990115] NET: Registered protocol family 2
[    1.990186] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.990387] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.990826] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.991015] TCP: Hash tables configured (established 131072 bind 65536)
[    1.991017] TCP reno registered
[    1.991019] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    1.991025] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    1.991116] NET: Registered protocol family 1
[    1.991131] pci 0000:00:02.0: Boot video device
[    1.991247] PCI: CLS 64 bytes, default 64
[    1.991252] DMAR: Host address width 36
[    1.991254] DMAR: DRHD base: 0x000000fedae000 flags: 0x0
[    1.991259] IOMMU 0: reg_base_addr fedae000 ver 1:0 cap c9008020a30270 ecap 1000
[    1.991261] DMAR: DRHD base: 0x000000fedaf000 flags: 0x0
[    1.991266] IOMMU 1: reg_base_addr fedaf000 ver 1:0 cap c0000020230270 ecap 1000
[    1.991268] DMAR: DRHD base: 0x000000fedb0000 flags: 0x0
[    1.991272] IOMMU 2: reg_base_addr fedb0000 ver 1:0 cap c0000020230270 ecap 1000
[    1.991274] DMAR: DRHD base: 0x000000fedb1000 flags: 0x1
[    1.991278] IOMMU 3: reg_base_addr fedb1000 ver 1:0 cap c9008020230270 ecap 1000
[    1.991280] DMAR: RMRR base: 0x0000007d458000 end: 0x0000007d46ffff
[    1.991281] DMAR: RMRR base: 0x0000007d600000 end: 0x0000007dffffff
[    1.991283] DMAR: No ATSR found
[    1.991291] Simple Boot Flag at 0x7a set to 0x1
[    1.991550] audit: initializing netlink socket (disabled)
[    1.991558] type=2000 audit(1319618693.984:1): initialized
[    2.011653] highmem bounce pool size: 64 pages
[    2.011657] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.019039] VFS: Disk quotas dquot_6.5.2
[    2.019105] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.019698] fuse init (API version 7.16)
[    2.019781] msgmni has been set to 1707
[    2.020091] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.020113] io scheduler noop registered
[    2.020115] io scheduler deadline registered
[    2.020127] io scheduler cfq registered (default)
[    2.020225] pcieport 0000:00:01.0: setting latency timer to 64
[    2.020253] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    2.020294] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.020326] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    2.020394] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.020415] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.020461] intel_idle: MWAIT substates: 0x220
[    2.020462] intel_idle: does not run on family 6 model 15
[    2.020521] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.020527] ACPI: Power Button [VBTN]
[    2.020567] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.020569] ACPI: Power Button [PWRF]
[    2.020591] ACPI: acpi_idle registered with cpuidle
[    2.134041] ERST: Table is not found!
[    2.134072] isapnp: Scanning for PnP cards...
[    2.134088] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.154441] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.486875] isapnp: No Plug & Play device found
[    2.536588] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.536663] serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.556662] 0000:00:03.3: ttyS4 at I/O 0xec98 (irq = 17) is a 16550A
[    2.557009] Linux agpgart interface v0.103
[    2.557092] agpgart-intel 0000:00:00.0: Intel Q35 Chipset
[    2.557145] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    2.557796] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    2.557895] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    2.558955] brd: module loaded
[    2.559454] loop: module loaded
[    2.559613] pata_acpi 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.559632] pata_acpi 0000:00:03.2: setting latency timer to 64
[    2.559641] pata_acpi 0000:00:03.2: PCI INT C disabled
[    2.559665] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.559678] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.559925] scsi0 : ata_generic
[    2.559993] scsi1 : ata_generic
[    2.560037] ata1: PATA max UDMA/100 cmd 0xfe80 ctl 0xfe90 bmdma 0xfef0 irq 18
[    2.560040] ata2: PATA max UDMA/100 cmd 0xfea0 ctl 0xfeb0 bmdma 0xfef8 irq 18
[    2.560323] Fixed MDIO Bus: probed
[    2.560345] PPP generic driver version 2.4.2
[    2.560377] tun: Universal TUN/TAP device driver, 1.6
[    2.560378] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.560442] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.560458] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    2.560470] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.560474] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.560506] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.560528] ehci_hcd 0000:00:1a.7: debug port 1
[    2.564422] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    2.564434] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfe9d9c00
[    2.580022] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.580158] hub 1-0:1.0: USB hub found
[    2.580163] hub 1-0:1.0: 6 ports detected
[    2.580244] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.580253] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.580255] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.580284] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.580303] ehci_hcd 0000:00:1d.7: debug port 1
[    2.584198] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.584210] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff980800
[    2.600022] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.600130] hub 2-0:1.0: USB hub found
[    2.600135] hub 2-0:1.0: 6 ports detected
[    2.600210] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.600221] uhci_hcd: USB Universal Host Controller Interface driver
[    2.600239] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.600244] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.600247] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.600273] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.600301] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000ff20
[    2.600397] hub 3-0:1.0: USB hub found
[    2.600401] hub 3-0:1.0: 2 ports detected
[    2.600451] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.600456] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    2.600458] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    2.600486] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    2.600514] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000ff00
[    2.600606] hub 4-0:1.0: USB hub found
[    2.600609] hub 4-0:1.0: 2 ports detected
[    2.600661] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.600666] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.600669] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.600698] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    2.600718] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000ff80
[    2.600813] hub 5-0:1.0: USB hub found
[    2.600816] hub 5-0:1.0: 2 ports detected
[    2.600868] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.600872] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.600875] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.600901] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    2.600921] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000ff60
[    2.601014] hub 6-0:1.0: USB hub found
[    2.601017] hub 6-0:1.0: 2 ports detected
[    2.601067] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.601072] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.601075] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.601103] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    2.601123] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    2.601215] hub 7-0:1.0: USB hub found
[    2.601218] hub 7-0:1.0: 2 ports detected
[    2.601309] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.604041] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.604046] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.604139] mousedev: PS/2 mouse device common for all mice
[    2.604244] rtc_cmos 00:05: RTC can wake from S4
[    2.604319] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.604340] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    2.604411] device-mapper: uevent: version 1.0.3
[    2.604476] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    2.604501] EISA: Probing bus 0 at eisa.0
[    2.604503] EISA: Cannot allocate resource for mainboard
[    2.604505] Cannot allocate resource for EISA slot 1
[    2.604507] Cannot allocate resource for EISA slot 2
[    2.604508] Cannot allocate resource for EISA slot 3
[    2.604510] Cannot allocate resource for EISA slot 4
[    2.604511] Cannot allocate resource for EISA slot 5
[    2.604513] Cannot allocate resource for EISA slot 6
[    2.604514] Cannot allocate resource for EISA slot 7
[    2.604516] Cannot allocate resource for EISA slot 8
[    2.604517] EISA: Detected 0 cards.
[    2.604525] cpufreq-nforce2: No nForce2 chipset.
[    2.604527] cpuidle: using governor ladder
[    2.604528] cpuidle: using governor menu
[    2.604530] EFI Variables Facility v0.08 2004-May-17
[    2.604773] TCP cubic registered
[    2.604887] NET: Registered protocol family 10
[    2.605403] NET: Registered protocol family 17
[    2.605415] Registering the dns_resolver key type
[    2.605429] Using IPI No-Shortcut mode
[    2.605492] PM: Hibernation image not present or could not be loaded.
[    2.605505] registered taskstats version 1
[    2.613594]   Magic number: 15:509:726
[    2.613609] block loop6: hash matches
[    2.613667] rtc_cmos 00:05: setting system clock to 2011-10-26 08:44:55 UTC (1319618695)
[    2.613931] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.613932] EDD information not available.
[    2.890284] Freeing unused kernel memory: 696k freed
[    2.890441] Write protecting the kernel text: 5332k
[    2.890478] Write protecting the kernel read-only data: 2188k
[    2.903426] udevd[83]: starting version 173
[    2.955585] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    2.955588] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.955626] e1000e 0000:00:19.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.955636] e1000e 0000:00:19.0: setting latency timer to 64
[    2.955714] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[    2.988047] Refined TSC clocksource calibration: 2659.983 MHz.
[    2.988052] Switching to clocksource tsc
[    2.989036] Floppy drive(s): fd0 is 1.44M
[    3.004055] usb 2-5: new high speed USB device number 2 using ehci_hcd
[    3.006039] FDC 0 is a post-1991 82077
[    3.136539] hub 2-5:1.0: USB hub found
[    3.136636] hub 2-5:1.0: 4 ports detected
[    3.266258] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:21:9b:6c:d9:7f
[    3.266261] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.266282] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 6, PBA No: 1041FF-0FF
[    3.266303] ahci 0000:00:1f.2: version 3.0
[    3.266318] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.266360] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    3.266425] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x2f impl SATA mode
[    3.266429] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part ccc ems sxs 
[    3.266433] ahci 0000:00:1f.2: setting latency timer to 64
[    3.296536] scsi2 : ahci
[    3.296599] scsi3 : ahci
[    3.296657] scsi4 : ahci
[    3.296715] scsi5 : ahci
[    3.296773] scsi6 : ahci
[    3.296831] scsi7 : ahci
[    3.298311] ata3: SATA max UDMA/133 abar m2048@0xf0000000 port 0xf0000100 irq 43
[    3.298314] ata4: SATA max UDMA/133 abar m2048@0xf0000000 port 0xf0000180 irq 43
[    3.298316] ata5: SATA max UDMA/133 abar m2048@0xf0000000 port 0xf0000200 irq 43
[    3.298319] ata6: SATA max UDMA/133 abar m2048@0xf0000000 port 0xf0000280 irq 43
[    3.298320] ata7: DUMMY
[    3.298322] ata8: SATA max UDMA/133 abar m2048@0xf0000000 port 0xf0000380 irq 43
[    3.376053] usb 3-1: new low speed USB device number 2 using uhci_hcd
[    3.616037] ata5: SATA link down (SStatus 4 SControl 300)
[    3.616068] ata8: SATA link down (SStatus 4 SControl 300)
[    3.784015] usb 3-2: new low speed USB device number 3 using uhci_hcd
[    3.788022] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.788084] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.788096] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.788578] ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-H653F, D200, max UDMA/100
[    3.788582] ata4.00: applying bridge limits
[    3.788881] ata3.00: ATA-8: WDC WD1600AAJS-75B4A0, 01.03A01, max UDMA/133
[    3.788884] ata3.00: 312500000 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.789288] ata4.00: configured for UDMA/100
[    3.789789] ata3.00: configured for UDMA/133
[    3.789898] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-7 01.0 PQ: 0 ANSI: 5
[    3.790073] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.790169] sd 2:0:0:0: [sda] 312500000 512-byte logical blocks: (160 GB/149 GiB)
[    3.790222] sd 2:0:0:0: [sda] Write Protect is off
[    3.790225] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.790248] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.790584] scsi 3:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-H653F D200 PQ: 0 ANSI: 5
[    3.792684] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.792687] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.792786] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    3.792843] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    3.808772]  sda: sda1 sda2 < sda5 sda6 >
[    3.809028] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.820827] ata6.00: ATA-7: ST3500630AS, 3.AAE, max UDMA/133
[    3.820830] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.879137] ata6.00: configured for UDMA/133
[    3.879222] scsi 5:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
[    3.879336] sd 5:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    3.879355] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    3.879378] sd 5:0:0:0: [sdb] Write Protect is off
[    3.879380] sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.879399] sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.918852]  sdb: sdb1
[    3.919059] sd 5:0:0:0: [sdb] Attached SCSI disk
[    3.935718] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input2
[    3.935809] generic-usb 0003:0461:4D22.0001: input,hidraw0: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[    3.935823] usbcore: registered new interface driver usbhid
[    3.935825] usbhid: USB HID core driver
[    3.976773] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input3
[    3.976834] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1a.0-2/input0
[    4.249102] EXT3-fs: barriers not enabled
[    4.263835] kjournald starting.  Commit interval 5 seconds
[    4.263873] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    6.773767] Adding 5952044k swap on /dev/sda5.  Priority:-1 extents:1 across:5952044k 
[    6.918998] udevd[339]: starting version 173
[    7.872254] lp: driver loaded but no devices found
[    8.573274] parport_pc 00:07: reported by Plug and Play ACPI
[    8.573327] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[    8.606300] ppdev: user-space parallel port driver
[    8.668216] lp0: using parport0 (interrupt-driven).
[    8.869098] mei: module is from the staging directory, the quality is unknown, you have been warned.
[    8.869395] mei 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.869399] mei 0000:00:03.0: setting latency timer to 64
[    9.001076] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    9.160172] [drm] Initialized drm 1.1.0 20060810
[    9.553148] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.553154] i915 0000:00:02.0: setting latency timer to 64
[    9.563349] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    9.563351] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    9.563655] i915 0000:00:02.0: irq 44 for MSI/MSI-X
[    9.563659] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    9.563661] [drm] Driver supports precise vblank timestamp query.
[    9.563687] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.595553] [drm] initialized overlay support
[    9.665598] fbcon: inteldrmfb (fb0) is primary device
[    9.665716] Console: switching to colour frame buffer device 210x65
[    9.665750] fb0: inteldrmfb frame buffer device
[    9.665751] drm: registered panic notifier
[    9.665800] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.842571] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.842615] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   10.842637] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.209817] type=1400 audit(1319618704.090:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=709 comm="apparmor_parser"
[   11.209826] type=1400 audit(1319618704.090:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=708 comm="apparmor_parser"
[   11.210161] type=1400 audit(1319618704.090:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=709 comm="apparmor_parser"
[   11.210181] type=1400 audit(1319618704.090:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=708 comm="apparmor_parser"
[   11.210376] type=1400 audit(1319618704.090:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=709 comm="apparmor_parser"
[   11.210404] type=1400 audit(1319618704.090:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=708 comm="apparmor_parser"
[   13.983717] EXT3-fs (sda1): using internal journal
[   14.638126] EXT3-fs: barriers not enabled
[   14.638289] kjournald starting.  Commit interval 5 seconds
[   14.638561] EXT3-fs (sda6): using internal journal
[   14.638565] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   14.665795] EXT3-fs: barriers not enabled
[   14.670156] kjournald starting.  Commit interval 5 seconds
[   14.670591] EXT3-fs (sdb1): using internal journal
[   14.670595] EXT3-fs (sdb1): mounted filesystem with ordered data mode
[   15.234167] RPC: Registered named UNIX socket transport module.
[   15.234170] RPC: Registered udp transport module.
[   15.234172] RPC: Registered tcp transport module.
[   15.234173] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   15.678542] FS-Cache: Loaded
[   15.697197] FS-Cache: Netfs 'nfs' registered for caching
[   15.863531] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   17.179725] type=1400 audit(1319618710.062:8): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=975 comm="apparmor_parser"
[   17.182032] type=1400 audit(1319618710.062:9): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=988 comm="apparmor_parser"
[   17.182391] type=1400 audit(1319618710.062:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=988 comm="apparmor_parser"
[   17.182613] type=1400 audit(1319618710.062:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=988 comm="apparmor_parser"
[   17.241404] type=1400 audit(1319618710.126:12): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm-guest-session-wrapper" pid=976 comm="apparmor_parser"
[   17.470765] type=1400 audit(1319618710.350:13): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=986 comm="apparmor_parser"
[   17.471249] type=1400 audit(1319618710.350:14): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=986 comm="apparmor_parser"
[   17.528932] type=1400 audit(1319618710.410:15): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=991 comm="apparmor_parser"
[   17.529311] type=1400 audit(1319618710.410:16): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=991 comm="apparmor_parser"
[   17.532185] type=1400 audit(1319618710.414:17): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=993 comm="apparmor_parser"
[   18.721170] NET: Registered protocol family 15
[   19.704225] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   19.760068] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   19.760294] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.179306] init: failsafe main process (899) killed by TERM signal
[   20.288623] init: apport pre-start process (1227) terminated with status 1
[   20.290601] init: apport post-stop process (1259) terminated with status 1
[   20.369102] init: gdm main process (1247) killed by TERM signal
[   21.144863] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[   21.144868] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   21.145017] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.416137] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   22.430530] NFSD: starting 90-second grace period
[   31.623427] vboxdrv: Found 2 processor cores.
[   31.623624] vboxdrv: fAsync=0 offMin=0x420 offMax=0x1360
[   31.623703] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   31.623705] vboxdrv: Successfully loaded version 4.1.4 (interface 0x00190000).
[   32.080011] eth0: no IPv6 routers present
[   32.151761] vboxpci: IOMMU not found (not registered)
[   33.289063] Bluetooth: Core ver 2.16
[   33.289081] NET: Registered protocol family 31
[   33.289082] Bluetooth: HCI device and connection manager initialized
[   33.289084] Bluetooth: HCI socket layer initialized
[   33.289085] Bluetooth: L2CAP socket layer initialized
[   33.289229] Bluetooth: SCO socket layer initialized
[   33.308860] Bluetooth: RFCOMM TTY layer initialized
[   33.308864] Bluetooth: RFCOMM socket layer initialized
[   33.308865] Bluetooth: RFCOMM ver 1.11
[   33.371418] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.371421] Bluetooth: BNEP filters: protocol multicast
[   36.006386] init: plymouth-stop pre-start process (1963) terminated with status 1
[   90.906141] show_signal_msg: 15 callbacks suppressed
[   90.906146] vino-server[2462]: segfault at 6f632f7c ip 019ef3ea sp bfd5fefc error 4 in libc-2.13.so[1980000+176000]
[ 3314.564026] usb 2-5: USB disconnect, device number 2
[59927.572020] usb 2-5: new high speed USB device number 3 using ehci_hcd
[59927.704604] hub 2-5:1.0: USB hub found
[59927.704677] hub 2-5:1.0: 4 ports detected
[60416.493372] exe (7724): /proc/7724/oom_adj is deprecated, please use /proc/7724/oom_score_adj instead.
[90189.008025] usb 2-5: USB disconnect, device number 3
[147313.352023] usb 2-5: new high speed USB device number 4 using ehci_hcd
[147313.484613] hub 2-5:1.0: USB hub found
[147313.484687] hub 2-5:1.0: 4 ports detected
[169509.080020] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[169509.080026] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[169509.080604] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 1640573 at 1640569, next 1640574)
[169509.080688] [drm:i915_reset] *ERROR* Failed to reset chip.

--XsQoSWH+UP9D9v3l
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i915_error_state.bz2"
Content-Transfer-Encoding: base64

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
Mqzd6zbDLlWGWWGmWGX8rDLLDTLDLhWGWWGmWGX8rTTLTLLDL+VpplpllhkVMMMLVllnnzbW
yWmn83ZVlbSIbGsfX/XON3OuZ/Y/a/anz6vz9t6zjJCEYLnhuaytpLTDlppWWmEtMOWmlZax
dX8y5bDTTTlpu2abMssMq0wyyw0ywy/mzLTTDZlhl02ZaaYbMsMuGzLTTDZlhl/NmzZpszzz
tpNnb0JlMjApLJpUNjcouSi5XXMDm8xfmp/ennNn7RQ9IQiz00yrK2ktMMMsqytlLTDprN1n
zDZlhl22ZaaYbMsMuGzLTTDZlhlWmGWWGmWGXxsy00w2ZYZeNmWmmGy5sbmjk3ODg2OTc2Nz
BzzR0c83zL6rA0+N9x69+/vvPO2sJaZfXppWWmEtMPGhWGWktMDLCsLZS0wtlasLZS0w81ee
7/Z1ikXL4xmyY4Md17a4505q5zGT0ocm5ybm5scu2zZs02ZZYZdtmzZpsyywy7bDTTTlpu2a
bMssMvGzLTTDZlhl42ZaaYbMsMq0wyyw0ywy/Nhpppw03bNNmWWGXLZs2abMssMumzZs02ZZ
Y510bt27LZllhlbTTTWdcbTbfP3fzz78rb1ved/nrv15v9+PXGXDTDLLdlpphplhlWmGWWGm
WGWzZlpphsywy3bMtNMNmWGXpsy00w2ZYZfGzZs02ZZYZeNmzZpsyywy/NmzZpsyywy8bDTT
TloaZ/bPTTDLxuy00w2ZYZeXtM97da+a+fPm/rW8+uPvOuvXG7L790y0t6Wyyw0ywy8bMtNM
NmWGX5sy00w2ZYZZaZaaYaZYZctmWmmGzLDLxsy00w2ZYZVoZYZaZYZfGzLTTDZlhl9bNmzT
Zlc2NypybtnP1t7xjeOa7n3ufcXR4bm5s2DR0dHdpsyywy6bDTLTZlhl22ZaaYbMsMvGzLTT
DZlhkaYZZYaZYZW0tllhplhlWmmmWmWWGXxs2bNNmWWGWWltMtMssMvrYaaacNN2zTZlk2Nz
RyScHBxqNa72uzyFhzk2jJ2fG5ycGx0ywy8bMtNMNmWGXxsy00w2ZYZeNmzZpsyywy+tmzZp
syywy+tmzZpsyywyrQyyyMjLDLTLDK2lsssNMsMvGzLTTDZlhly2ZaaYbMsMstMtNMNMsJnH
LYVhpslph400rLTCWmHbTSstMJaYeNNKy0wlph40JlMvGRWGWyWmHjTKsraS0w8aZVlbSWmH
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
/pgx1TBjqmDHQujHQujHnBkx8/Bkx0Lox0LowPyIY6F0Y6/TfjHfhdGOqYMdUwY6F0Y6F0Y6
pgx1TBjqmDHVMGPPjCY+fGORdGOhdGB8r/xRdGOvK8+R/GOhdGOv7zfjHfqYMdfyb8Y79TBj
r+TfjHfqYMdfyb8Y9KIY+ZWMd+pgx0LowPyIY/lTBjqmDHVMGOvK8i78Y6pgx1TBjqmDHVMG
OvK8i78Y8qIY+VUMdUwY6pgwPyIY6pgx1TBjoXRjoXRjoXRjoXRjoXRjoXRjoXRjoXRjoXRj
yohj5+DJjqmDHVMGB+RDHVMGOqYMdUwY6pgx1TBjryvP6YMdUwY68vzox0Lox1TBjyohj58Y
5F0Y68rPkUx1TBjr9N+Md+F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y84MmPlVDHVMGOqY
MD8iGP+NTBjqmDHX8m/GO/UwY6pgx1TBjqmDHVMGOvP3wxjqmDHVMGPODJj5+DJjqmDHVMGB
8/fCmP6qYMdeX50Y6F0Y6F0Y6pgx15XkXfjHVMGOvIxjry/OjHQujHnBkx8/Bkx15XkXfjAi
5MdC6MdeV5F34x0Lox0Lox0Lox15XkXfjHQujHVMGOqYMecGTHz8GTHQujHVMGBFyY6F0Y6p
gx1TBjqmDHQujHQujHQujHXlefI/jHQujHQujHnBkx8/Bkx0Lox0LowIuTHQujHQujHQujHQ
ujHQujHQujHQujHQujHQujHQujHVMGPODJj5+DJjoXRjoXRgRcmOhdGOhdGOhdGOvK8/3m/h
jvwujHQujHQujHQujHQujH/KF0YoXRj5VQx15GMdC6MCLkx/rC6MdUwY68jGOhdGOhdGOhdG
OhdGOhdGOqYMdC6Mf8ryviRDHz8GTHQujHQujA9NGGpgx15XkXfjHQujHXlef8Tfwx34XRjo
XRjoXRjoXRjqmDHnBkx8/Bkx0Lox15WRcmP8wujHQujHVMGOv7TfjHfqYMdeV58j+MdC6Mde
V5/TBjoXRjzgyY+fgyY68rz+mDAi5Mf7VMGOhdGOvL86Mdf2m/GO/C6MdUwY6F0Y6pgx0Lox
0Lox0Lox5wZMfPwZMdC6MdUwYEXJj/aF0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F
0Y84MmPnxjmmDHVMGB+RDHVMGOqYMdUwY6pgx0Lox1TBjqmDHXleRd+MdUwY6pgx5UQx8qoY
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
Nve+ZGRvL/vm8ZMpsbmvk8q/750fz/8do8zMaGv3/Cjz+fy08MjMpl7/iQ/kPze/hf8QvKTq
beg0VfGv/F+d2/jI7r5fGvy/8J/P5/fO/s4yyr/cbbM49bYtj/dWze2mz1iZyvP+7Y332rGd
918vjRff8R/P51Y3/rG3kZj985+NfL5VI1Xxl5Vj83za/5j+P8P5438/kQ3n/m+/l/D+ffvv
5RCQpN7yMreX7/FavK/m8/odfJ5V/550fzw7QreZEPU/2/WN8b4m+7WMsq/3G+zOGlX/uber
zL1frfTOsD/CJrWhq+NHBGLG5/x7cb1mt/1zj/Ge4bRweknJ009NDTLT0ywy/1s2bNNmWWGX
xs2bNNmWWGRoZZZWyMsstMsMv9bNmzTZllhl+bNmzTZllhlloaaaf60NMtNmWGX+tmzZpsz/
msZzr53573229YvXqa527z5v6/f59L9N2zTQ0y0+MsMt2zZs02ZZYZemzZs02ZZYZe2w000/
mhplpuywy+tmzZpsyywy/mzZs02ZZYZGhlllbIyyy0ywy6bNmzTZllhl/NmzZpsyywyy0NNN
d/5/m+++13/YvHvJfGSH/tOjNj/J8kH8h/Elk6q6feYzdcNPlymk9ZGhoJuyE2GOf2773v6y
8vcJcm38tt3z926aunifn0v2sHrBox8/Bkx/mF0Y/4QujAi5Mf7XyMY/z+pgx/teV/yi78Y/
2hdGP9ryv+7+mDH+8Lox/vC6Mf7wujH+8Lox5UQx8/Bkx0Lox0LowPleRdGOhdGOhdGOqYMd
eV58j+MdC6MdeV5/TBjoXRjoXRjzgyY+fGOaYMdC6MCLkx153wxjvwujHQujHVMGOhdGOhdG
OhdGOhdGOhdGOhdGOqYMecGTHz8GTHQujHQujA+V5F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y
6F0Y68rz/U38MevAfErGO/C6MdUwYEXJj+Xleab8Y79TBjqmDHVMGOqYMdeV5/4Tfwx36mDH
VMGOqYMeVEMfKqGOqYMdC6MCLkx/iF0Y6F0Y6/k34x36mDHVMGOqYMdUwY6pgx15XnyP4x1T
Bjz4PjJj5+DJjoXRjoXRgRcmP6hdGOhdGOhdGOhdGOvK8i78Y6F0Y6F0Y6F0Y6F0Y6F0Y84M
mPn4MmOhdGOhdGBFyY6F0Y6F0Y6F0Y6F0Y6F0Y6F0Y6pgx0Lox0Lox0Lox0Lox5UQx8/Bkx0
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
iIiIiIhERERCIREQiIREQiIREQiIiIiIiIiIhERERERECIiIiIiIiIiiIiIiIiIiIiIiIhER
EQiERERERCIiIhEIiIREQiIiIiIiIiIiIiIiIiEREREREIiIhEQiIREREQhERERERERERAiI
iIiIiIoiIiIiIiIiIhERERERERERERCIiIiIiIiIiIiIiIiIREREQiEREREREQiIiIRCIiER
ERERERECIiIiIiIiIiIoiIiIiIiIiIiIiIiEQiIiIiIiIiIiIhCIiIiIiIiIiIiIiIiIiIRE
RCIiIiIREQiERERERERERCERERERERCIhEREREREQiIREREIQIiIiiIiIiiIiI9IhEYiIiER
EREREREQiIiIREREQiIhCIiIiIgRERERERREREREREREREREREREREIiIhERCIhERERCIiIi
IiIiIiEREREREIiIiIiIiIiIRERCIREREREREQiIiIiIiIiIhERERERERERERCIiEQiIiIiI
iIQiIiIiERERCIiIRERCIiIiIiIiIiIiEREREREREREIiIiIiIRERERERERFZuWzajuum7G2
wu47sbW6sprYrsSbbqlrLjsSbbtQtbuNsmzlbprsS1FtpNrbRbaSbrTsUjbu7ExrakIiqjiK
IqiIiIiba6RZG2ukWQiOIoiba6UbuSIiiIoiKIiiIoiIqJbbJLu2ltaVG7CIiIwiERERERCI
iEQiIhEQiIiIiIiIiIREREREIREQiIiEREREREREREQiERERERCIiIiIiIiIiIiIiIiIiIhE
REREREQiERERERERCIREREREQiIREQiIiIiERERCIiIiIiIREIiIRERCIiIiIiEREIiIiIRC
IQiIhERERERERCIQiIiIhERCIiIiIiIREREREIhCIiEREREIhEREREREIiIiIiIiIiEREREC
IiIiIiKIiIiIiIiIiIiIiIRERERERERCIiIREREREIhCIiEQIiIiIiIiIiKIiIiIhERERERE
REIiIRERERCIiIREREQiEREREIRCEIiIiIhEQiIiIiIiIiIiIiIhCEQhERCIiIiIiIiEQiIi
IiIiIhCIQhEREREIiEREREREQhEREIiERCIhERCIhEREREIiIiIiIiIiIiIRERERERERERER
ERERERCEQhERCERERERERCIiIiIiIhEREREREREIiIiIiIREREREREREQiIiIiIhERERERER
ERERERCERCIiIiIiIhEREREREREREIiIiIiEREREIiIiIiIiIgIiIiIiIiiIiIiIiIiIiIiI
hEREREREREREREREQiEREREREIiIiIiIiIiIiIhEQiIREIiERCIhEQiIhEQiIREIiIhEQiIR
EIiEREREIiIiIiIiIiIiIREQiIREQiIiIhAiIiIiIiIiIiIiKIiIiIiEREREREREREQiIiIi
IiIhERERERERCIiERCIiIiIiIiIhERERCIiIiIiEREQgIiIiIiIiIiIiiIiIiIiIiIhERERC
IiIRAiIiIiIiIiIiIiIiKIiEQiIhEQiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIhEIiIi
IiIiIQiIhERCIRCEQiIiIiIREREQhERCIRCIhEIREREQiIQiIhERCIRCEQiIiIiIhERERCER
EIhEIiEQhEREREQiEQiIiIiIiIiIiIiIiIiEREIiEREREREREREREREREQiIiERERERERERE
RERCIhEREREIiIiIiEQiIiIhERECWwxjF4xbAAAAACIAAAAAAAAAAAAAAAAAAAAAAAAAAARA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAEAAAAAQCIAgAAAAAAAAAAAAZWAAAAAACAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAEAAAAAAAAAAACIAAAAAAAAAKAAAAAAAAAgAAAAAAAAAAAABAAAAAAAAAAAAAA
AAAAACIAAAACAAAAAAAAAAAAAAAAAACAAAAAAAAABAAAAAABAAAABEAAQAAAAAAAIAAQAAAA
AAAIIAEAAAAIgAAAAAAAAAAAAAECAAAAAAIAAACCAAAAQAAAAAAAAAAAABEAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAABEAEAAAAAAAAAAAAAAAAAA
AgAAAAAAAAAAAAAAAAACAAAAACAAAAAAAAAAAAAAAABAAAAjGYpEFRQLjCYQhEQpVAkVAiKU
pRAIRRIIAioqEpBIRBSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAMrAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAgEQB
AAAAAAAAAAAAAAAAAAAAIAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAA
AAAIgAAAAAAAAAoAAAAAAAACAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAIgAAAAIAAAAAAAA
AAAAgIIBAIGLsZu2LsLuwAAAAAAAAAAAWsAAAAACAAAAAAAAABAAAAAABAAAABEAAQAAAAAA
AIAAQAAAAAAAIIAEAAAAIgAAAAAAAAAAAAAECAAAAAAIAAACCAAAAQAAAAAAAAAAAABEAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAABEAEAAAAAAAAA
AAAAAAAAAAgAAAAAAAAAAAAAAAAACAAAAACAAAAAAAAAAAAAAAABAAAAgAAAABEAAAAAAAAA
AAAAAAAAAAAAAAAAAAIgAAAAAAAAAAAAAAAAAAAAAXi8YxgmMRaXMAEABAACEBACQQgACBCB
AEAQCACCAAACAEAFIUAAgBEARQAAAACABEBQQkAIQAAIIQQIgAACAAABBAQhAlAgACRSCCig
AIEQAIKCABCECJAQAQQCACAAAAIgAKQQAACAEUBAAQAgFIQBAAAQAEAAChAAABAAAgARAAIR
IEABCCkiCAAACAAAACCBAQhAEBBABAAEAACCCIQAAigIpEQAIAKQKIChQAhBECEQCkIQEEQA
ABECCAgUAABSAAQCIAgAQAiRACkEAIAARIpCCgAACAFICCgBAAAQAAACCABCKCCAEKQiABAU
AEqJUAABBAAIQBAAAACAAABAQQAKCCAAAQAAAABCEAQEACAEAIiFAAAEAACAAIIAARCgAEQA
CACIAIEAAoBEUikUikUikUikUikUiRAERFAoESAiQFAAREAiJBSIigIigAIRAIioERQERQAh
CIgERUCIoCIoESAiJARICgRUCQIkCJASAkBFBEgRIESAkCJAiigEQAilIikISIQiikJEAERS
IUQiESIhFIRCREUkRFKACKRCKAIpEIKREUiEIhFAABEgoACIkACBFCIiREAQIgiIiKEIQhCI
ikRFIiIiIAEIiIiIkURIgAERERCIiKRBFKFIghBCIEERBAAAIAQAgIAigUgIIIUoURBCAIAA
pEREQikRFIpFEIUEBCEIEIQgoAEBCIgEIBRAQhEAQiEUEKUCEEEKUKICEAQAEFEREQiIiIiI
iIiIkUBAAhIAAAAQgUREQpClAhBAkABCgAQghQIkEFAABQACEEBFCQAACIRAAAAChFIUQCgA
BABACAKCIIAhQIEBEBAIiIgpClCIEEgQiIIiEUgoggggCgABABAACIBEQikUikUikUikUikU
ikUikUikUikUikUikUikUET/hYKUCCClCiCAIEAKIiIikRERAIiIpQBAAAQEBCCAFKERERER
ShEEKRSFIgIQiiCCEKFBABEICIiQUIiIgKUBBBAQgIIkFEREUoQghSIQhERBRBBBBBRBCIiA
QCgAEIQEESChEQCIiIiiAUAAiEAUIkBFKAkVAEIAIAEJEgoiIiIIilCEECRVAIQAKgikUSEh
FEhCCiCCAhBQAACACkgkEERERREIhERREQCIUBBQAAgAgEAIBEhRAEKBAgIQIEAoRERERERQ
QghREQREREREREREiIiAAREERShEEKQIgAQikUikUikUikUhSKRSKREUikUikUiIiKQIgAIo
UQQCgECIAIAIAAFEBCIUAEKFEEAQIBQiIgohQQAiIKAAEAoKAAACCClCiCAIAAAgIAiAIIil
CECCoKFKVFAFEQVBSlFKgFFQUKUqKCAoiCoKUopUCBIpQhCBEABCEUUACEACEIQiAECBFIoB
QERSAURFJCISkUSBURFUBFIRQIoghAohCikAAAAIQRSURKBBQBEEKIQEhBCIJEUohRAQIEQh
AqBURCIVCIRESBFEUIpERUAggAAAAAAACEVFKBFCkIRFKREKQUhBSRSJERCKQopSREEFKVCC
IqRKgiiFJEIUIghAgoRRAiKEUQiopIxdrzdy4tKBNV12SrcXBxFVxRVVkCIiKKAkRIgCiQUi
ighSlIiAESFIJEUlKhFFQgIIVCJeLrEIJFARKSKIEkQkKtKuKSFQpKpRCVRKKRKVCSJCSJCU
KURISIkiIgqFUFXcuUKIokUKFEuYvBEIlApFKMYxMBUFRBIRC4ktBRQSKAiiKUiJC7lpRCIU
iFQUQCggKUhARSICFJSApIpEQJCkEJCUiAlCkiAikghVKIqAkEERCiikqIFQRREQFFIihKAk
SFEUqKUFRESCIQFCRSIQqKUURFIokFAkUioUiCkiIRRSEFIQSKIoSEhEKIkCQhIREREkKSIV
AolCEEpCkiFBCRFFIoQgpIiECICioqFBSKREhVKFCKRKRFIlQqlVEAggRLu4IQUAEQpUKRBC
EIiUEQRAilEhRIIgQqBEIIlAhIpAAESEUIUlCkgJCRIRKEhCIFBSKEClIpFEQKAogiAIRSAi
CoKKURQIoSBIIgpIqEUIIQUiEESKFQQBAIAUpKSAoBUSJQpSQUioRICCQQoiKQQkEURUUSFE
QKVCEgKREIiiIUSCQIoiREiCCoEUQiCJFSIkCiEVFKJIhFKoSKokSCREiQIqkiQRAUpQoghE
VSKIkRAEVCVBRSKhEkEQhKQhUKREIpREiIpCJCKhFKgRFIgCIIpUKIgIhEEURSkKKVARSRCE
IUREIEIiIJCCESKQgRFRKUgiICgUiFQSBEChSIhBIUKEUAIkSlCBERKVCIpSkKoiIKgUUqAi
EUiBREKiQVQgUtcvGKwlKpjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAEA
iAIAAAAAAAAAAAAAAAAAAABAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAA
AAAAABEAAAAAAAAAFAAAAAAAAAQAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAABEAAAABAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAATSwAAAAAQAAAAAAAAAIAAAAAAIAAAAIgACAAAAAAABAACAA
AAAAABBAAgAAABEAAAAAAAAAAAAAAgQAAAAABAAAAQQAAACAAAAAAAAAAAAAIgAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWsAgAAAAAAAAAIgAgAAAAAAAAAAAAAA
AAAAEAAAAAAAAAAAAAAAAAAQAAAAAQAAAAAAAAAAAAAAAAIAAAEAAAAAIgAAAAAAAAAAAAAA
AAAAAAAAAAAABEAAAAAAAAAAAAAAAAAAAAAAzmMYrFLQhCEIQhCEIACAgEAgIAAAEECAEAAA
BQEAIAIAAUBACAQBAICAUFAoEBAQCAgICAgICEAIAIggIBCCAAQIAQEAgiCIACAgAgCBAAgA
AIIAAQAAQCAAACKAACBAAAACIKAAAAgEQQghBAABAAAACAAACAiAEBEEEAAAAQAQIQgFAAAA
BAAAgAAEAAAAQCIAEBEEAAAAAgAAAIgAAFAAAABAgCCIAAUACEABCAoCAQAAIAAgIBBQAACA
AAAAgQQgEAAEAEAAECIABAABAAAIIgAKAQECBAAAIAAIAIAAAAQhCEIQhCEIQhCEIQhCEICA
RACCIIQAAgBQgQAAIgBAAAAAQAEQAEQAQggCAgAQggQAQQCIoQACKAggAQAihAIgAQAAgAAI
AAAEAAQIARQgAAIAQABBAECARAKSAIQAAASKEAAiAAUkAQgAUEIQghAEAAAgAAAAUoUACAAg
ACACAACACAAACiAAgAAQAgEAAQAEAAAEAAABEAEAAAQhCEIQghCECEIQgEAAAghBAIAAAIAI
AAEAAgAEEIAAQCACBQAAIAAIBAgAAACCIIQAAAAAAAACIABQgiKQAgFCIhFAQoQRFIAIBQiI
RQBEQAAABBCAAAAIEAAAIQBBVURVUVcU01N3dVI1N3dHd8YAAAAAAAAAAAAAAAAAAAAAD74A
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA8H2Pvvv9DYAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAPbYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAA3d3d3d3d3d3d3d3d3d3dtNzNAQRMcRwW13UHHKzCxMBMcwZdNzcVwUcwyLYWq1jNtNA1
xVzAHSkHMycww3aFQtVRFREVUXTahURURWJt3d3d3d3d3d3d3QAAAAAAAAAAAAAD74+PbfYA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADePvjxtvY9sfb7733
xvG+x8fB/oHr5+Xx7774+++wAAAAAAAAAAAAAAAAAAAB4APje+8BtgAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA++Me+PjfbC1uDm0jrtmw7trqmsbqNuauv
2AAAAAAAAAAAAAAAAAAAAADY+MY32AAAAAAAAAAAAAAAAAAAAAAMe+wfb2MG+AAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMfHgMbrk7mtu7SKu66KO1Loo
6RuVG5uu2k7NubmljWuzbu7u7u7u7oAAAAAAAAAAAAAAABqa3Rh1zSHUUdSKdydUt3d3QAAA
AAAAAAAAAAAAAAAAAPG98ePb/T72PsfGPYPtjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAbYDfeD2/0/+Hve9/z//r/H+nve/6UO3+Z4iszQDx/q/7gf3
/WLne4/ep3/1f7HU6b00/3G+KunS6CD5Az/m/4YB7/aXF8M4qgnZI9Hb/k/P349zsYC5i4V/
l1wP9vf/l+3+vf9P+v2H4aAAYBmYd8MP+ZDMkzO6Zn44ZCoB/sTMz8cMzygB4TMz/YhmTPZD
CZwMP9DVVX/JVVX/CpVf8lSekqp/qVVf8J7SVXSpVdKlV0lVXSpVdJVV7VKrpVVXpUqulSqr
pVVXSpVdJKrpVVXSVVdJVV0qqrpVVXSqrPrmZn1MzPqAH1wzPqZmfUAD6mZn1CSdKqq6VKrp
VVXSSSdJVVXKVVcqlVyqqrlJJOUqq5SqrlVVVcqqq5VVVyqqrlAD44ZnxzMz44Zn1AD65mZ9
QA+uZmfWVVdJJJ0lVXSVVV0lVXSqqukqq6VVV0qqrpVVXSpVdJJJ0qqrpJJOlSq6VVV0qqrp
VVXSpVV0qqrpJJOlVVdKlV0qqrpVVXSqqulVVdKqqt7Tpgc3hgIQRVRdaoVHaV/52dckVEWp
dWmVtavObNLQ1dzSxq8YuAggIYu7XBGLs/Xti5lYJSIQJCFT9dgVIISIQSEhEQSfruICkEii
QkAiqn5JXSSThJPict0nv1Z8WRhKqu1Sq3VVZ+pmZw4Zn65mZnxAD4gB8TMz0gB8SqrlKqu1
Sq5VVV2qVXSVVdKlV0kknSpVdKqq6VVVXSqqukkk6VVV0kknSSq6QA+uZmfUAPrhmfXDM+oZ
n1AD65hn1qqrpJVV0lVXSSq6VKrpKqulVVdJJJ0lVXSSq6VVV0qqrpKqulVVdKqq6SSTpRmZ
9TMz65mZ9QA+uZmfXMzPqAH1AD6gB9QzPqGZ9QzPrhmfXDM+oAfXDMzpVVXSqqulVVdKqq6S
qrpVVXSqqukqq6VVV0qqrpKqukkk6VKrpVVXSqlTSSSaSSTSpVaVUrSqlV0kquklV0kqulSq
6SVXSpVdJJJ0qqrpKqulVVdKqq6SqrpVVXSpVdJJ6qSYqakYuT7194+/uM7ufetr4+8Y09nd
JDMzMzMzMzMzMzO7szMzMzMzMzMzM7uzMzMzMzMzMzMzu7MzMzMLaAAAAAAAAAAAAAAAAAAA
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
jfBJJAJJJJJ0kkgW2+eNLhK2u1ttpWS3u+Fok22ESWZ37+++iTy1tt2laXXt1Ld3PnzKd1xf
v73ck6Vt3u5ISXq5RJzNrcCQCSSSSQI1+h26t3SDKNsCNsBtsCNgRtsCSStpJdxzfd0kfBG2
+bbfB7776FtpJJbJJJJJH8+WmZmY228jaXLU1VySSSUSSSSEJNPa3ssbSkiUm7rboSWySNt2
kjAkjbAjfOTzyB3dzbba4VpbW25JJJGA2wG2wJJJGkkvfUkA3u/v7+gIAAAfz4AdmYliT9La
p0j1JIbOzIkkksFwq2clu7raSVb6ZkS1effmZMJX3dJG0uo2wJJI222wJa227RtqSJHd5P3/
J4K/V6vVixcoqhCTge+++++uV0cvvvvvcbpvvvvkAtbdtkk+/fv7Ld+/fu++++gD5tpd3Vub
mZERrvWiLZracaUlE597OuO7t2N0bo7u3R3Lu6O7pmMxEC3d3bBVu+h3REhAJmI7uVUiF7qw
REREdERERd7Mz0zOZuZvRERER0yMzMyAHd3fu7rvUREwB7t3d3cAC7Fqt3d3bvd2IiOIlpZk
QqxFxFwABmZmZmdmZJJJJ277/dxbZ/Hnn3755JPfcgSST32/vtO733vv36+7u7d3d3dAN3d2
27u7u7u2SR+Wntv3f7fPPLb7JJJaSSSSSSb55555AHG2222BAkjbdvnz5777affv37993ubb
D7979/f32RcDbfdz4JJ76eeecl/f393d9+skkkkkkgbv37/G7qaQEnst33330A9Pv9/d3d73
Pu6T3g3d3bfPny7uvuH5b5556laY27bwSST0DffffQD58+SS1tIWpqrlEIQhCEIQhCEISc8e
/z2WXjzz++/f7++7vb29P7+/szMxvq/PPPP4CSTd3YDbbZJ7776fCmdVEzMWqqdiIjJrFXES
qUKqpN2AmgdyIgsm7um7u5ZEiEiCLu2Zu8zH0AXd2ABmZJJOkkkC23+fnh987u97q22lZLe7
4W+K7vtUqwA4PprumZme4Hm5ELERZFOgZ1dvfrdK273ckJL1ef399z12+6BAJJJJJAjDt3d3
cvtl999tp76B7776Aegb7776AST7+/v7ISeySSMCNt822+D3330LbSSTt3d3d3d1/PncZmZj
bbn391rt/X/XzlEkkkhCTT2t7LG/N3+/t1txuhJ27u++++9wRgSRtgRv3d/v7Q3d+/fv375t
Rwdzbkm7u76A27a22BJN33+/p5776kA3vz58AoAAA/nwA99/v7sLb/PW9xLw97793fKzM3Li
Y/WFnqqLZl6Ld7tZZdLKyhnTu7dxCrvATIAzLt3d3cADXd3zAIzMxBJkco2Xzz3sc3qBJJJJ
JJAAAAAKf4AAAAH379+/fv36AAAAAbu7u7u7ugAAAAAAAAABCc6e/f8v5J/Hkfr7p2cO9kz5
6dv3P6Ycdd4fD4fD4MplfAXxCKriy4jH70pbvu7Y7tAvc4uzMzMzBd73AAAAAAAABpJe+fl8
/V++7+rxHvqf36BoUJh+/4Hd3d3du7vAAAAAERERERERCu1lYOLWjJFil9a1qIiIiIhVSIjz
wAAAA+W22222y0AAAAAAAAAAAEjvgPlBGaAkRO5foBEzPM1FUAALv1d7DSZvecfUaTLUJGYA
LuK5N7xNzdHc7u8RERERERERERERERERERERERHmbn7f3332ZgBmYdd8ePHjx3H/Zz7OjJKT
nTY1zdirq85zMrSyWrONpnNSVWc3Mec88bbVJO+8ddBVVVXKfJOpfYyVX+27HX6lnVKkzqVt
Mz7IBQJozTyYqUbn53shbGeGcGGvkOXoLCStEQlTPdjWgYa7quXuQ6gQflqTBq99SjSSjwHT
GsRqELqHoWkzIS/YspamYetpn1q7KJxQSYXN7h3GTXeli5iUeZcFfjY4R7g79DlRRzGaG7yU
DMtz53TC0nCpiqNHQ1pSl940qc8NZ5rNf4jANj+psXedxjbMtEYSklCfBlftVMKpq18MG0RQ
m88s1Nc3KmKtiLQCxI97a1nWPMEZkkuiz3p3oPzpbLrN081G32J0AkTbOkaDh+rQGBJYd5rI
xSCiLhXmcpVK43aPYJbiMiJvWG1pd3x5b+jNvzgZ9qtXD4QnHr9utzzvtt+fPv59lVVVUklV
U19al0tITdaUTmt1KxQxNCquqM1ASXJma9fLyu7JSGvn99nlXTpGo471r6h257RSlj7vNzz8
52LxjN2MXkvGMx8ux8P14NubhWfU2uak2vjBmXZevnvb1d3Nb530evWNGJ629Hu73PUz6K9+
thiYq6xRYuEXcawVjE/TVej3vvzt+xfkkk59etV8VJCpISqhVTKVNm6YVhVYSS1q9KwymVZV
lMplJ0c6OZJP1zM8IAuB9TJAJMOiYC4AoAuGSSZkhOGTkgC4GSEmYTgKZ8TJPLi5mdUFOjk4
KeHMNdTBTO6GprmahrmuBOeHon44GofGcwknMxTFyTs6rmZguZqaz8k2VX1pNKrZUrSYbJlW
yfE0rSVsmEwrZKtKymUwqZTZs0rZVBbZU0mmVaT6k+JJ6StlaVWyek0k003SW+Pz0np9VMMJ
6eknp6bNm6TDCaT4tXtXx9EmyfX1K2TZsJPaT2m72qbpum6TdXpXpW760+J9e1TDZXp9YSfW
m7d9V7bq+pafWU9p7bvb2rCTKbPSp8fEwmUr0m6t2ntLbpbLQ2Wrdllpu9MJ8bphPTdC1fWG
U3fE9vifXtl6UYV7YZT2n19YVu0ky9p6bNPrD6mWz69vrSrYfE2ZTT0n1WE09PTdRXpphWz2
09Paabp7e3tVq9Pr0+rT6n1N0+pLV9fEymzdhNlWmlYfFbtmntMN2yvT2009K+grCfGGFYV8
ZZVhMJRUJbCYTDCYTDCYTDKtkwwrCaZTLT6mybJpNNJllMstlZbJMplMsqyymWUmWVZZVllM
spMpsntlJs2bJurLdNNJpaaVu3TTSaTTSabppWmk00mk00mm7dJpLVs0mUmVZTKsplWWUymV
ZZTTKrbJlsmlbJllMqymzCW2bNJlpVtNNK2SQnSqtMp8fVTSpNDqh1Tq4dXDXUzXA6p1TUOi
BILhrmanRw6IahqdHDqgamuBinVAXJJySQnJnBcmczFMmQD2mC4AuALgC4AuALmZkmGuTmE5
OBJJhJIHhDXNcMnMxczwmoSsqmUq0yyhlKyqYYVKtLVWFVhhVYZZVMJhKJafkq2WGUmGWUmE
wwkwyyrDDCsMMJMMN2kmGGFZTTKVhMMKmGGFTTLSpatJpWlaZSaVpNJhWFS1WwrCTdMJs2TZ
Kw2ZVls2TSqtVpluqbtN2ybN0rZs0m7KTdpu3bK2TdWmFTdu03bN26pummWUhW7du00nCWmz
Zs2aTZU9J6SZSFek9JurKjZXpunx7bKorSbplK3e3tsmzduqbt27dN35XpXxPjSaVp7SbJs2
fE3BPSQmyZZSTLLKsqJMsssoSEwwrKZVLSWJMsqmUtlCsphMJMphJllCppN2EhUwwwhsmmmk
0hppMspNkyrLKaSaaVWWUmzKVllJllsqaTStNJMjKZZVkZTKZTZppNNJpppNNJpppNPit2my
aaVNNJpWmkmk00mkmzTQ0k2VMt2kmUmzDLZhumyt2zZsrZNmGUqem6sK2emzLdMJU3bq0k3b
tmW7ZWFbNlbtmyVMpMst0kN1YYSt0tWm6bKrdpJutlVZYbJskm6ps2bJutlJpLVhN1qhhpMs
KyqtJskwhlNJhJDCphMK0rSqwrSaVNKy3bps/NK4VU9q3VWzZVq9t26T23VlK9paqtPaYVha
QCZ/EJ1Cc1nVckP19vV6uGvV1w9KlaZbJsqpslbJKy02W9t06Sps0my2zZNlSbNNkts2SflS
e1T2r2rKVPb09re3thuqpsmGy2zZMJuqq9NmU2TZMNlT6qae2lTSaSYS3p6ZbrVNk2SYVbZs
y2S0mybJMJbZsy2Wk2TZJhK3TZhNlqmypaV6W0lpMqlt3pVe2U3ctmXtPqfnpXpw9uW6Vu3S
bpu9vabpN2W70qe1tmypsmzSpsltk2SbNmkmy2yZbKmz49sJ7boVu3SaTdN2G7cTdXxae0nx
sm6tK2S2ypsmzZWlW9vabvj49N0r49t0nxN26bqm6bpurdunppsqbre3pN3pbZWyTds3W9j2
qfE3emVexhMJXtp7e3sbt0ntpls3ex7aekrC1bvbYbt1e2zDdMN243bKP1Mz0himZ+/8OP+c
AA+4gAGZnXYAwAcQDMw+IABgbmIAAAeMxAwAOgo5mGZmYeAcAwwAhAzEEAcczAzDMzN/F6+q
/N3daS2tjen1P3PXTw9M/GeolMe9Y/dY/Hr+3WY6J71jewnfHqbKcrrret97ldvG1t8Tb3Lx
+nqGJ+mt5Rd4496vWbx6nG/vffGNpxmqqpPSSiSEkKolEkKokokkqpuqqKlSEqFVVHAFMMXM
wFzMUFDAMPTmApgLmYCimKGCmApgouABmHZA+JnRDXJzXXDXMXAWQFAUkBczFMXJMU1wJnMk
waMBcBHDD6BgcCBmfqAAcYIAB0AzAzMzoEAAWBhiAAaIAAcoAAB15mlBQUFBQUFBQUFBQUVK
CUFUSQqgqqJIVCUSoEqEokhCSBUJAlQkhJCEkCpAqipCSFUFUQlAVQFUVRVEkCUVRVFQhVFU
SEqFVAhUKokgUVCiqhKCSFUEKhUCFQIElFUVUKohKJKCVIVCSQkoqEkJVQKIFSQlElUUSECp
KRVIhIUEhIVCpIFVKJUKhJCqKJUKoIVCoSpRVQlEhIVQFVKKJUhKolEqipRJCiSiqCFQkkhU
lFFVIQlVRKKkKIiIqqIVKJCpRIVQVRJCqhVFVRVFUEhCpUKqqJRUJCqKkhVQqSEookohUkJK
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
FB8fkKfD774H5DZmZmWI6vex3uu6iWK2mPJG3wJHwP0kAlAB8fkKfD8U+075vvfqWIfnN6zV
Lv3cquHXWrVClI7ELEYww1AH2QPksfiSQSD8SASAe+On68RzHsRjDRlXjy6aMcXeM++GiASA
SAYHrnPPa6vu+7he9Trej1u2hjZdCfvgfnIBKfffH5Cnw++APye92/fWtt1jMQr722W1PT7g
8fXz8PwOMwAhMAfjZmDkwZgOTD74AH6e4xfWtxCq/FxZO7loa/fHGfZZmmGxjzdu3397/h4w
DjA8HrPeZ3zPeH72A7phgfiAk2YYOTGZmYLmYYkwAOXd7fv7+efPX79aEi3ORMci21x5tu5w
J++AP0lPvgfkKffH5CAd+TOXfp63eImtK3FfqpOjI3jvvhBAJAJANt62d50sZ6yu/FjGEiGZ
veV9ab4cIBIBIE/VEmeb1/mc2yYv/xpvqUBAJ8uwhKAjy7EQEJQEAm92Audrpu7VVVSSqr3Z
2qve7tQLVVVUqn6mo7SNKC1VVVAv7u27tVVVIo1VI0u/INeibbtUkqZVI0Lir2To9OlVVVVJ
Ji1VVfm7tVVVVSyDSqtVVX9u6qqKLI1UqqL83dkaqVVBaqqqqquN3aqhZBpZlaqqquElRQ2q
qlVRav7d2RqrFUlqqqpVP6tRrxu7UsyLVVVUq/zm7VVQyLVVVUocuTtVQyKLVVVgoLVVDKi1
VVSTy5u1VUMi1VVSSpym7VVTItVVWKLVzu7Uqi1VSSoVVVc7ai1VVYpVVULJ+0O1VVSzg1VV
VVI1zSihqSoVLUtXNCrtLUoLUEk87ugqrI1I1VVUqry7suSTUq1KtShzSrtYouLhVkPEsSEg
ECHmbjF3d2hFSNVKpUqyc7KaijVVVVVSqVZzWpNSqKqqpUq8pO0q1YoVSKKNVM1VVVVVVVSq
LVVVyztVVVVVVVVVVKq8s7VVVVVVVVS5VUvNG1JOLii4tVVXO7tUg1lSrVUuKq8u7VFQtS4u
C4vNZtYuKSSqqSTyk4q5tVVVVSNVVLzu7i4uKqgsihPLrmqrVVIooo1VVVyk4KuLiquKu1zu
6qrlVVSkkrI1Vzu6VVTijUjRVJjXO7tWSKE5Ii0LIo1zsKO1VUiiiiiLVUg1zsO0ijVU5Mii
jVVUkOSNVKtUjUig0LzsO1ShIuTVVI1kPNDsVSNLihUEinNYKK7VLINLIoo1zu7VkiiijVUi
jVUjUnLhri4ahJJKry5qGpUuFWVZVVy6ijtI0siijWCycpkiigoKBrIpy5Coo7SKKKKKTIo1
zsLiima1SKKKZPKbtIooiCk1VSKTnKagO0iiigpK4c7YKO0hIVTgopzQ7LhIouNSLgcpOCij
sEgooKS0TIio1I0tUiiijUnNuyKCKjQVYq4ScoGuYq5hry4SO1UjUgo1VI1VzsKKarOLk1VV
SNVc7u1SNSKNSNSKNSNSKc27I1kjRI1Io0FWcpOa4KTi4uSNSc0ayCjSyKNVE4Nc7CjtVIo1
Io0LIuTzsKO1Ug1Io1UFQc7CjstUiijUjVQHOw7ZI1OTIo1Io1I1zsDtIo1I0EjUg1Jzbsij
UguNVZVI1VJzQ7SSoVVTi5MjTQ1VIo1I1I1VIo1Ic26Ek5I1I1VI1Io1ym7VSNSKNSKKKNSK
NcuaihqSTUpVVVJzbsjVVVQsjUjUijVXO7tUjVVVRVVVI1I1Vzu7ODVVVUjVS1SKNc7u1VBV
VVUVVEjWc1qNVVSNKtQtUjVXNajVS1STUtRVI1Jzbq1VSNVLiquVBzu6q4qrVUqyNSTVzu6p
UVVVKtSqVLzu7UtSrJIKtVSnKbsuVYtWLJNVUjXO7si5NVUjVUijVVVTNVVCNVVVVSNVVVHK
ajtVVVVVVC1VVU8U7FI1RerXVcUU6/6dXU5SV6dN2p6UmI5xLzdkRKUBCGmsLlzPOMBCUBAJ
zdhCUBAJzdhCUGruATm7CEmEsEAnylU8/m7qU37rpr2pzpX9u7VVVMkjQtVVVS/N3ZGiRqpR
ahaqpOrrqNLVUtVVUjUk1f27tVRVVVI1I1VUKf2ymtQKuKKqqv9WrVVUkqqqoq1c6TtVVI1V
UVVSNSNSc27VI1Ii1VVJNVVVWet3ZFGskaqkayFqqqTih2qCoWqGVxcXilXBdqqZqkGlON3c
JBpSrFkaqqq4dR2yrFKpBRQak/kkXNapwUaqCRSmqkUUaqkUUaqJBT+oUdpFFBcUXJnFOXJH
acFFJXMknnd2RcmcXGpGqpFGuU1HaqRqSZGqpJkak5t2qRSapGiqcXBTm3ZwaXMVcJGs53dW
qSZJJJzJBTlDXNRcxQmTGuUNTFDWSQkxTlDJFB2kFGqqudh2CRRRRqRqRqRRTmgdskUUakaq
WRqo5TdicGpGgqqwXnd2RRqQJxcWrKudh2kUXBRRRqRRRRSoUUUayRqqRqqRqRTly2qMWqRo
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
u6tvW3RsG4NxKLOSuLEjMHDna7a7QBgAMFbXbW25EkKSSISUlet+eeZ54GY3dVSE0g0G223z
bbbkbbrbk6R9W223WzukjYNtt22Sc0klwNyNttsCSEiR+93d3N93T332/PiWJscSzI3rAkkk
klkkkkm27vtVogOS5L3zzzuz33OCSSNsEsPHbu7W3LZbJJJJGBJJIBJJJJISSNIBgNpRJAPu
6SASSSSSSdEklwNxttttgQJI22Avnxthkxtt5ObbelGz9/f3LUxtt93PgkjbElyWpJd2N4d0
kkkkkLJG2iRLEgkjctjbYEbG0u7m+b7ukb4JJIAvnySTLcaVqSSVpjbtvBJJGwI22BJJa227
bUtTfnj7i3ua7kkt3W3Y/PPPM8D/ju7pJOBtttH+xtv/fnzM7F55J55u7uc223kSU88zPP98
88++Z77uf6LgbxJLfPn225u7rWpJtNfPlr8b3ZI3wSSQCSSSSdJJIFtvnjS4StrtbbaVkt7v
haJNthElmd+/vvok8tbbdpWl17dS3dz58yndcX7+93JOlbd7uSEl6uUScza3AkAkkkkkCNfo
durd0gyjbAjbAbbAjYEbbAkkraSXcc33dJHwRtvm23we+++hbaSSWySSSSR/PlpmZmNtvI2l
y1NVckkklEkkkhCTT2t7LG0pIlJu626ElskjbdpIwJI2wI3zk88gd3c222uFaW1tuSSSRgNs
BtsCSSRpJL31JAN7u/37q9N3878bzaJldtVjNWARVZMzqqQ4MiboEXFHibsRVPFpovb23t25
mx3qB068sw2Fvk9o2qxVVdWiZmZ7feZmZl7ajSs3f1lEPqqq++8ZxEcryu2BsZO7VCqqZyd1
bsV4fO+LgrR93O7v1mczLdlVLv3YuahljV5VbaqdEznBVVE0bTS7u/R3dfXdrunu8qxD5Ts3
YtkDlM1mbaqs6VXkSkIqrrl56qqqmZme6vdO1SqAJD9bfv37bVV/burFhvmW+ZUn1bpPmkhA
d5xoDu4A94d26Tu75mIdsbVV31dbF7xYnb3d3VVDnd9iOpDoKKpVtVdzikjFCqdV2demewS1
WT1VHIhZjNJh+B0kVj3IAzMOD7shjqqgXfgNDvMma7u905kRERnA7DqqZ3Zns3323333L+El
vcpJHZu7u90YN+Lxbv3756MD6AffoDefPmZWm37ennh291/e+8/jfTOmZ0nudCItlgbbuse7
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
uu7dqSaBJJ8U5MxrDKswqDN3VEalVb169evXrv6+iqqmzmnyutdVZZoin5NqsSSSqISSSiIS
SSiISCChvVc5MRbe1WLx3nIuaqZWcXu86iugN7sC7sC7sC/375vn5+/az6n6bPp2nTNNde1q
XzTdqYkEGUQkklEQkklCgJJN8Xi+ut6Vd+85u0zT3x7uOszazDHydqHPfnffPPrz0al2eXYF
3YF3YF/v22fy8ifenERabR6rwsNi9eh/RNYJJJ2iEkkoiEggoiEkgolNgI14azpeXzHXeHtK
Yervvd/37zmA+rAu7iIu7CL+/d/upjPr1+5jfY3M71M7bVQ0TzizuuEkgqUBJJREBJJREBBB
b4Af++x+z+1L/viCKZ/3560H3+jkGIjkM+gAAAAAAAAAAAAAAAAAAAAAAABmZmXf80+Abu7u
6AAAAAAAAAAAAAAAAAAAAAAAAHnnnnngAAAAHn95yD2EXn9mpaqmqtVXKoScGNtt5K6N9zbf
cSQjbS4LW3bZJJG20rTm2223gPm2l3dW3rbY2+b3h8lyzFVixJDDjmA7XbXaAMAErbbWx93J
JSSRAl3c220kqkZjYQSSbQa7W222Ntt5I2xt93SThttttskkkYDbbYElrSStG3I222wJITzw
7u7u5vu6Ntnz59+793cYlu63GwJJJJCSSSSSTpG0uAC1JJe+pW1t2kkkjbGlgLLZI23LZbJJ
JJGBJJIBJJJJJJI2gG7XGkkstbkklpJJJJJJJ55554B7G2222BAkjbbt8+fG3bcG232g229d
b/z/GttBtu2u0kkbPPPPPPGku7m2d3SSSSSASRtLd8fngEkctjbbAjBpK2u122SO0kkkDz58
JIgG0Hnj88tu63tvBJJIwI22wF+/v7JLcxIUTVXKIQhCEIQhCEIQv/dneZL5nU5d3+pJL31J
ST/evf61Ulq3dbo4kkkgkkkkge+++++kkbbPnzM7wStqUk3W2+e80pyS1ISSWYpGJBddSSO+
cGzMzzxpe+pefPkI092SRvgkkYEkkknSSSQH+22rUkNO12+++++eWSW93wt88jbd3zzDOcYh
KGNt4E5r9/ZMxZmOfPnB1zFS1akXGy2pVJepJJfcTtbAgEkkkkgRtB0kUkldtbbtI2A22wIw
I22wJJObSS47m+7pGUjbfNtvuBttFtpJJOkkkkknvz5OG2/ffffTI2ly1NVcohCEkkkhCTT2
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
6vwP14qWaOnnfCpS/3DPWKj/aDh3tvzQzS9EX6FM+Tpt4iBCu2LBebknDvd1znp2OI1XmrGb
u784Y7tsrVdEavnnn9y3TOOdGj0qqwIqr91c1rEjBE5d0aN+99m/V1nz9hbtBzEHkjpzfPS6
47F/1tNhdYXEvEtF7y2vu3fvb397137/vncqdzGYje7AtYRa4EFEwu1Vc55GIznmIxG7TVU2
dZfUyePQIJNjKI1CozKI148cbvH5457/ffffm9vmvr746xzx5x5fV9+nkEe1kFrgi7uIL9+9
83mqEYqfNO97ndc57b6zUymphKBJB8iAgkoUJBBREBJB0t5u3pdml+85tecretYlV5xN7Vdl
VqKmc8zGteokEnxQEkFETZQEmxQEkFNlTYdGamdS270NarXJm61U6zp8VAIJPiyIu7gi1kRb
56x7ed9c7P3H7n7t3+3779/fM9z5769bdc+eoI8WRF3cEWsgv2fYHoFR6FrWpWu9WfVmULz6
dvNXBJB2iAgkoUJBBREBJB369Y1uu0rx3nN61nGQc7jukb3qqKlc6z7XFn0rUuAPmCWJBooS
CShQEkFEQEElLaZd7jMZjXhkZfU6WrVar16c47ifNyI93cEWsgtcEXfPPW1/e8+ba81S9eZm
zZz7Ha73s3M8oEEmxQEkFEQEElChIIKJ3vdd73WofDZz3D40kVNLmMvqRPHoEkejKKzCo1CI
/5YARz36++nvx755/uP7vObW1uan3d/vyZTEL+5a0q7S0pCSp/d++RASfIhJIKFASQURAQQU
73nea9QvL9Ztaqd1znvXPr1v53367z1jwg/eYwEYXAXdwFmnr+37WsO73fh3vq1xGaqq8XjG
KUEEHiISSCiISSChQEklB7yXEj1VT7p+czQ5yt+iac7azxtx5pYd3cRF3YRd2Eev9kknYz+Q
AADVc+kzgdA/TNaGq/Rz6IiOR2NxEREAAAAAAAAAAAAAAAAAAAAAAB+Znz8zMy6fAJN3d0AA
AAAAAAAAAAAAAAAAAIiIiIiIiIi973vERERERERERH9/9k//3+j4AMzM293d3+/ihlX/G3P8
O05aqqqqqqr/puDKeg7SB/zDb9zCl/RDP+tSSowINJsWIS18BHqNmyD2orlMJW5xB0ItnGN+
a5JQ0H6HNalZszW7zfeL10bmx+bjs1IRp1yk3sgrWUZySOZaOcdityhNcW1RKrlHXXtszUti
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

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="lspci.log"

00:00.0 Host bridge: Intel Corporation 82Q35 Express DRAM Controller (rev 02)
	Subsystem: Dell OptiPlex 755
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation 82Q35 Express PCI Express Root Port (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Memory behind bridge: fe800000-fe8fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation 82Q35 Express Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Dell OptiPlex 755
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at fea00000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at ec90 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at feb00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation 82Q35 Express Integrated Graphics Controller (rev 02)
	Subsystem: Dell OptiPlex 755
	Flags: bus master, fast devsel, latency 0
	Memory at fea80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:03.0 Communication controller: Intel Corporation 82Q35 Express MEI Controller (rev 02)
	Subsystem: Dell OptiPlex 755
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f0000800 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>
	Kernel driver in use: mei
	Kernel modules: mei

00:03.2 IDE interface: Intel Corporation 82Q35 Express PT IDER Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: Dell OptiPlex 755
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 18
	I/O ports at fe80 [size=8]
	I/O ports at fe90 [size=4]
	I/O ports at fea0 [size=8]
	I/O ports at feb0 [size=4]
	I/O ports at fef0 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_generic

00:03.3 Serial controller: Intel Corporation 82Q35 Express Serial KT Controller (rev 02) (prog-if 02 [16550])
	Subsystem: Dell OptiPlex 755
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
	I/O ports at ec98 [size=8]
	Memory at fe9da000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network Connection (rev 02)
	Subsystem: Dell OptiPlex 755
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at fe9e0000 (32-bit, non-prefetchable) [size=128K]
	Memory at fe9db000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at ecc0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at ff20 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 17
	I/O ports at ff00 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 22
	Memory at fe9d9c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 02)
	Subsystem: Dell Optiplex 755
	Flags: bus master, fast devsel, latency 0, IRQ 45
	Memory at fe9dc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: fe700000-fe7fffff
	Prefetchable memory behind bridge: 00000000f0100000-00000000f02fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at ff80 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 17
	I/O ports at ff60 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at ff40 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Dell Optiplex 755
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at ff980800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801IO (ICH9DO) LPC Interface Controller (rev 02)
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 0211
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 43
	I/O ports at fe00 [size=8]
	I/O ports at fe10 [size=4]
	I/O ports at fe20 [size=8]
	I/O ports at fe30 [size=4]
	I/O ports at fec0 [size=32]
	Memory at f0000000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
	Subsystem: Dell Optiplex 755
	Flags: medium devsel, IRQ 9
	Memory at fe9d9b00 (64-bit, non-prefetchable) [size=256]
	I/O ports at ece0 [size=32]
	Kernel modules: i2c-i801


--XsQoSWH+UP9D9v3l--
