Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2HANkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:40:41 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49072 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2HANkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:40:36 -0400
Date: Wed, 1 Aug 2012 15:38:35 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: roland@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: mellanox mlx4_core and SR-IOV
Message-ID: <20120801133835.GH5470@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 01 Aug 2012 15:38:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to use SR-IOV virtualizaton for Mellanox ConnectX2 card with
mlx4_core driver with kernel 3.5.0. I built firware for the IB card with
sriov_en = true, lspci shows:
02:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s
- IB QDR / 10GigE] (rev b0)
        Subsystem: Super Micro Computer Inc Device 0048
        Flags: bus master, fast devsel, latency 0, IRQ 24
        Memory at fbd00000 (64-bit, non-prefetchable) [size=1M]
        Memory at f8800000 (64-bit, prefetchable) [size=8M]
        Capabilities: [40] Power Management version 3
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=128 Masked-
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [100] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [148] Device Serial Number 00-25-90-ff-ff-28-09-08
        Capabilities: [108] Single Root I/O Virtualization (SR-IOV)
        Kernel driver in use: mlx4_core

however, the driver complains:
[    3.558221] mlx4_core 0000:02:00.0: Enabling sriov with:4 vfs
[    3.558296] mlx4_core 0000:02:00.0: not enough MMIO resources for SR-IOV (nres: 0, iov->nres: 1)
[    3.558299] mlx4_core 0000:02:00.0: Failed to enable sriov,continuing without sriov enabled (err = -12).

Is there any workaround for this? Or the bug is in BIOS and without a proper
fix this is never gonna work? 

Perhaps, are there any persons more suitable for these kind of questions?

-- 
Luká¹ Hejtmánek
