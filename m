Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0EUNpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 09:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab0EUNpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 09:45:40 -0400
Date: Fri, 21 May 2010 15:45:04 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: bkl: Pushdowns for sound/oss ?
Message-ID: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf

I was looking at doing some of that last remaining ioctl bkl-pushdowns, in 
particular in:
sound/oss/swarm_cs4297a.c
sound/oss/msnd_pinnacle.c
sound/oss/sh_dac_audio.c
sound/oss/vwsnd.c
sound/oss/dmasound/dmasound_core.c
sound/oss/dmasound/dmasound_core.c

when I noticed they were including asm files from mips. I went so far as 
to compile my own mips tool chain, but I wasn't able to compile the above.
Being oss sound, I was wondering if these are still maintained or are 
marked for removal some time in the future.

If there is merely a problem with my toolchain, then that can be fixed, 
but there is no point in wasting time with these if no-one uses them.

Thanks

John
