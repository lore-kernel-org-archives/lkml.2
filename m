Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1IHDGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:06:11 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:58515 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757938Ab1IHDGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:06:10 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.1-rc5 dont boot
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Wed, 07 Sep 2011 23:06:05 -0400
Message-ID: <web-603103654@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recompiled 3.1-rc1 for see the problem again, with 
loglevel=8
I get the following messages:


c1024274 no_context+0xbf/0xc7
c1024409 _bad_area_nosemaphore+0x18d/0x198
c10a7fb4 ? get_page_from_freelist+0x24b/0x293
c10a5a07 ? __zone_watermark_ok+0xe/0x91
c10a7c79 ? prep_new_page+0xe/0xfe
c10a7fb4 ? get_page_from_freelist+0x24b/0x293
c1f35cca ? raw_spin_lock_irqsave+0x1d/0x3a
c102442b bad_area_nosemaphore+0x17/0x19
c102472e do-page_fault+0x157/0x346
c1f35d26 ? _raw_spin-unlock_irqrestore+0x16/0x18
c15e2ef1 ? vgacon_scroll+0x29d/0x2bd
c1021e14 ? native_irq_disable+0x8/0xb
c1008d10 ? native_io_delay+0x8/0x30
c15e1b5c ? vgacon_set_curser_size+0xf7/0xfe
c105a54e ? notifier_call_chain+0xe/0x4f
c105a5d7 ? atomic_notifier_call_chain+0x22/0x24
c102468b ? mm_fault_error+0xcb/0xcb
c1f3be37 error_code+0x67/0x70
c1007396 ? apply_alternatives+0xaf/0x167
c10a7fb4 ? get_page_from_freelist+0x24b/0x293
c10a84cb ? __alloc_pages_nodemask+0x104/0x5de
c24fd18d ? relocate_vdso+0x1b/0x266 (or 2bb)
c24ef501 alternative_instructions+0x1a/0x10e
c1021e5a ? native-write_cco+0x8/0xd
c24f065c check_bugs+0x155/0x15a
c1087094 ? delayacct_init+0x50/0x54
c24e880a start_kernel+0x322/0x337
c24e82fe ? kernel_init+0x116/0x116
c24e80ac i386_start_kernel+0xac/0xb3

Then dont happen nothing else, the cursor continues
to blink, the keyboard don't react to input

config  like before

wl

---
Professional hosting for everyone - http://www.host.ru
