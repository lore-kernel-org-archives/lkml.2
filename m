Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab1IIOWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:22:08 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:54896 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179Ab1IIOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:22:07 -0400
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Sep 2011 10:22:07 EDT
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Subject: [3.1-r5] x86 build warning in =?utf-8?Q?=E2=80=98arch=5Fprepare?=
 =?utf-8?Q?=5Fkprobe=E2=80=99=3A?=
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEX///8ZGXBQKKnCrDQ3
 AAAAJElEQVQImWNgQAAXzwQg4SKASgAlXIEEiwsSIYBEcLaAtMEAADJnB+kKcKioAAAAAElFTkSu
 QmCC
Copyright: Copyright 2011 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 09 Sep 2011 10:12:32 -0400
Message-ID: <m31uvpvm6v.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc-4.6.1 warns:

In file included from include/linux/bitops.h:22:0,
                 from include/linux/kernel.h:17,
                 from /usr/src/lugabout-github/arch/x86/include/asm/percpu.h:44,
                 from /usr/src/lugabout-github/arch/x86/include/asm/current.h:5,
                 from /usr/src/lugabout-github/arch/x86/include/asm/processor.h:15,
                 from /usr/src/lugabout-github/arch/x86/include/asm/atomic.h:6,
                 from include/linux/atomic.h:4,
                 from include/linux/mutex.h:18,
                 from include/linux/notifier.h:13,
                 from include/linux/kprobes.h:34,
                 from arch/x86/kernel/kprobes.c:43:
/usr/src/lugabout-github/arch/x86/include/asm/bitops.h: In function ‘arch_prepare_kprobe’:
/usr/src/lugabout-github/arch/x86/include/asm/bitops.h:319:2: warning: use of memory input without lvalue in asm operand 1 is deprecated [enabled by default]

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
