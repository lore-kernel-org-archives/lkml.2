Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0EUOmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:42:25 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57241 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0EUOmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:42:21 -0400
Date: Fri, 21 May 2010 15:40:56 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: bkl: Pushdowns for sound/oss ?
Message-ID: <20100521144055.GB13174@linux-mips.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:45:04PM +0200, John Kacur wrote:

> particular in:
> sound/oss/swarm_cs4297a.c

This one is specific to the Swarm, a MIPS-based platform indeed; I'll cc
Maciej Rozycki who most likely is the only person on the planet knowing the
technical details.  I don't even recall touching that file so my (C)
header in there is a surprise :)

Stiching up the build problems in that file.

> sound/oss/msnd_pinnacle.c

Random weirdo ISA sound card.  Probably only ever tested on x86 and will
have the chances

> sound/oss/sh_dac_audio.c

SH3 specific.

> sound/oss/vwsnd.c

Belongs to the x86-based first generation of SGI visual workstations.

> sound/oss/dmasound/dmasound_core.c
> sound/oss/dmasound/dmasound_core.c

Motorola 68k-specific.  Adding 68k maintainers to cc list.

> when I noticed they were including asm files from mips. I went so far as 
> to compile my own mips tool chain, but I wasn't able to compile the above.
> Being oss sound, I was wondering if these are still maintained or are 
> marked for removal some time in the future.
> 
> If there is merely a problem with my toolchain, then that can be fixed, 
> but there is no point in wasting time with these if no-one uses them.

More a problem in not reading the research properly :)

  Ralf
