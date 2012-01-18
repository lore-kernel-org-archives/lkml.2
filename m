Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2AREVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:21:38 -0500
Received: from trent.utfs.org ([194.246.123.103]:47911 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab2AREVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:21:36 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 23:21:36 EST
Date: Tue, 17 Jan 2012 20:13:45 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linuxppc-dev@lists.ozlabs.org
Subject: =?UTF-8?Q?error=3A_=E2=80=98cpus=5Fin=5Fcrash=E2=80=99_defined_but_not_used?=
Message-ID: <alpine.DEB.2.01.1201172006310.2895@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

compiling today's git (mainline, a25a2b8) on powerpc32 gives:

  CC      arch/powerpc/kernel/crash.o
cc1: warnings being treated as errors
/usr/local/src/linux-2.6-git/arch/powerpc/kernel/crash.c:49: error: 
‘cpus_in_crash’ defined but not used
make[2]: *** [arch/powerpc/kernel/crash.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2
make: *** [sub-make] Error 2

I think I've seen some discussion on the list where 
"treat-warnings-as-errors" for powerpc were discussed a while ago, but 
cannot remember for sure right now. Full .config:

    http://nerdbynature.de/bits/3.2.0/

Thanks,
Christian.
-- 
BOFH excuse #149:

Dew on the telephone lines.
