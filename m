Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2AHPSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:18:04 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42268 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab2AHPSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:18:02 -0500
MIME-Version: 1.0
Date: Sun, 8 Jan 2012 23:18:01 +0800
Message-ID: <CAAJw_Zt4WvTbnw+qxR-+tGCHZ9APkk0Cp0gTMRbdtTN58_udQg@mail.gmail.com>
Subject: Linux-3.2.0 Pid: 1902, comm: modprobe Not tainted 3.2.0 #64
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest git pull commit at 02550d61f49266930e674286379d3601006b2893.
Got several of these messages in dmesg ...

vmalloc: allocation failure: 0 bytes
modprobe: page allocation failure: order:0, mode:0xd2
Pid: 1902, comm: modprobe Not tainted 3.2.0 #64
Call Trace:
[<ffffffff8107e954>] ? 0xffffffff8107e954
[<ffffffff8105e423>] ? 0xffffffff8105e423
[<ffffffff8109cddf>] ? 0xffffffff8109cddf
[<ffffffff8105e423>] ? 0xffffffff8105e423
[<ffffffff8101bc5c>] ? 0xffffffff8101bc5c
[<ffffffff8105e423>] ? 0xffffffff8105e423
[<ffffffff8105e423>] ? 0xffffffff8105e423
[<ffffffff8105f33f>] ? 0xffffffff8105f33f
[<ffffffff8105fc58>] ? 0xffffffff8105fc58
[<ffffffff814e9639>] ? 0xffffffff814e9639
Mem-Info:


------------[ cut here ]------------
WARNING: at drivers/base/core.c:194 0xffffffff8129298b()
Hardware name: 5413FGA
Device 'machinecheck1' does not have a release() function, it is
broken and must be fixed.
Modules linked in: i915 drm_kms_helper
Pid: 2352, comm: power Not tainted 3.2.0 #64
Call Trace:
[<ffffffff8102a0ac>] ? 0xffffffff8102a0ac
[<ffffffff8102a15f>] ? 0xffffffff8102a15f
[<ffffffff814e8a69>] ? 0xffffffff814e8a69
[<ffffffff810fd353>] ? 0xffffffff810fd353
[<ffffffff8129298b>] ? 0xffffffff8129298b
[<ffffffff811e4b29>] ? 0xffffffff811e4b29
[<ffffffff814e144d>] ? 0xffffffff814e144d
[<ffffffff81044c72>] ? 0xffffffff81044c72
[<ffffffff8102b717>] ? 0xffffffff8102b717
[<ffffffff8102b74c>] ? 0xffffffff8102b74c
[<ffffffff814c701d>] ? 0xffffffff814c701d
[<ffffffff814c7110>] ? 0xffffffff814c7110
[<ffffffff814c901d>] ? 0xffffffff814c901d
[<ffffffff810fc424>] ? 0xffffffff810fc424
[<ffffffff810b26cc>] ? 0xffffffff810b26cc
[<ffffffff810b2803>] ? 0xffffffff810b2803
[<ffffffff814e9639>] ? 0xffffffff814e9639
---[ end trace 78b4393914412b97 ]---

------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:119 0xffffffff8103476f()
Hardware name: 5413FGA
Modules linked in: i915 drm_kms_helper
Pid: 1693, comm: rs:main Q:Reg Tainted: G        W    3.2.0 #64
Call Trace:
<IRQ>  [<ffffffff8102a0ac>] ? 0xffffffff8102a0ac
[<ffffffff8105857d>] ? 0xffffffff8105857d
[<ffffffff8103476f>] ? 0xffffffff8103476f
[<ffffffff810585dc>] ? 0xffffffff810585dc
[<ffffffff8104376d>] ? 0xffffffff8104376d
[<ffffffff81043a2e>] ? 0xffffffff81043a2e
[<ffffffff81018fe6>] ? 0xffffffff81018fe6
[<ffffffff814ea05e>] ? 0xffffffff814ea05e
<EOI>  [<ffffffff814e9639>] ? 0xffffffff814e9639
---[ end trace 78b4393914412b98 ]---

------------[ cut here ]------------
WARNING: at drivers/base/core.c:194 0xffffffff8129298b()
Hardware name: 5413FGA
Device 'machinecheck3' does not have a release() function, it is
broken and must be fixed.
Modules linked in: i915 drm_kms_helper
Pid: 2352, comm: power Tainted: G        W    3.2.0 #64
Call Trace:
[<ffffffff8102a0ac>] ? 0xffffffff8102a0ac
[<ffffffff8102a15f>] ? 0xffffffff8102a15f
[<ffffffff814e8a69>] ? 0xffffffff814e8a69
[<ffffffff810fd353>] ? 0xffffffff810fd353
[<ffffffff8129298b>] ? 0xffffffff8129298b
[<ffffffff811e4b29>] ? 0xffffffff811e4b29
[<ffffffff814e144d>] ? 0xffffffff814e144d
[<ffffffff81044c72>] ? 0xffffffff81044c72
[<ffffffff8102b717>] ? 0xffffffff8102b717
[<ffffffff8102b74c>] ? 0xffffffff8102b74c
[<ffffffff814c701d>] ? 0xffffffff814c701d
[<ffffffff814c7110>] ? 0xffffffff814c7110
[<ffffffff814c901d>] ? 0xffffffff814c901d
[<ffffffff810fc424>] ? 0xffffffff810fc424
[<ffffffff810b26cc>] ? 0xffffffff810b26cc
[<ffffffff810b2803>] ? 0xffffffff810b2803
[<ffffffff814e9639>] ? 0xffffffff814e9639
---[ end trace 78b4393914412b9a ]---

------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:119 0xffffffff8103476f()
Hardware name: 5413FGA
Modules linked in: i915 drm_kms_helper
Pid: 2503, comm: default.hotplug Tainted: G        W    3.2.0 #64
Call Trace:
<IRQ>  [<ffffffff8102a0ac>] ? 0xffffffff8102a0ac
[<ffffffff8103476f>] ? 0xffffffff8103476f
[<ffffffff810578ba>] ? 0xffffffff810578ba
[<ffffffff81018fe6>] ? 0xffffffff81018fe6
[<ffffffff814ea05e>] ? 0xffffffff814ea05e
<EOI>  [<ffffffff811ead77>] ? 0xffffffff811ead77
[<ffffffff8107f0e4>] ? 0xffffffff8107f0e4
[<ffffffff8107f49d>] ? 0xffffffff8107f49d
[<ffffffff8107f49d>] ? 0xffffffff8107f49d
[<ffffffff81049aaf>] ? 0xffffffff81049aaf
[<ffffffff8108f37b>] ? 0xffffffff8108f37b
[<ffffffff81023b9c>] ? 0xffffffff81023b9c
[<ffffffff81049aaf>] ? 0xffffffff81049aaf
[<ffffffff8108f46d>] ? 0xffffffff8108f46d
[<ffffffff8108ee8c>] ? 0xffffffff8108ee8c
[<ffffffff810927e1>] ? 0xffffffff810927e1
[<ffffffff81020bd6>] ? 0xffffffff81020bd6
[<ffffffff810905b2>] ? 0xffffffff810905b2
[<ffffffff811e693f>] ? 0xffffffff811e693f
[<ffffffff81089d6b>] ? 0xffffffff81089d6b
[<ffffffff810958a7>] ? 0xffffffff810958a7
[<ffffffff814e91b5>] ? 0xffffffff814e91b5
[<ffffffff811ec547>] ? 0xffffffff811ec547
[<ffffffff810ebd53>] ? 0xffffffff810ebd53
[<ffffffff810ece0a>] ? 0xffffffff810ece0a
[<ffffffff810b722c>] ? 0xffffffff810b722c
[<ffffffff810b2942>] ? 0xffffffff810b2942
[<ffffffff810ec129>] ? 0xffffffff810ec129
[<ffffffff810ebc56>] ? 0xffffffff810ebc56
[<ffffffff810b6d25>] ? 0xffffffff810b6d25
[<ffffffff81047c2d>] ? 0xffffffff81047c2d
[<ffffffff810b722c>] ? 0xffffffff810b722c
[<ffffffff810eba94>] ? 0xffffffff810eba94
[<ffffffff810b8913>] ? 0xffffffff810b8913
[<ffffffff81035614>] ? 0xffffffff81035614
[<ffffffff81009015>] ? 0xffffffff81009015
[<ffffffff814e99fc>] ? 0xffffffff814e99fc
---[ end trace 78b4393914412b9b ]---

------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:119 0xffffffff8103476f()
Hardware name: 5413FGA
Modules linked in: i915 drm_kms_helper
Pid: 0, comm: swapper/2 Tainted: G        W    3.2.0 #64
Call Trace:
<IRQ>  [<ffffffff8102a0ac>] ? 0xffffffff8102a0ac
[<ffffffff8103476f>] ? 0xffffffff8103476f
[<ffffffff810578ba>] ? 0xffffffff810578ba
[<ffffffff81018fe6>] ? 0xffffffff81018fe6
[<ffffffff814ea05e>] ? 0xffffffff814ea05e
<EOI>  [<ffffffff81220708>] ? 0xffffffff81220708
[<ffffffff812206eb>] ? 0xffffffff812206eb
[<ffffffff813d1f9d>] ? 0xffffffff813d1f9d
[<ffffffff81001501>] ? 0xffffffff81001501
---[ end trace 78b4393914412b9c ]---


Now suspend/resume seems to broken again!

Was very stable pre-3.2.0.

Thanks,
Jeff
