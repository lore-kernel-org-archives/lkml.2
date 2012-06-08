Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093Ab2FHGad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:30:33 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:46892 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387Ab2FHGab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:30:31 -0400
Message-ID: <4FD19B29.4050904@snapgear.com>
Date: Fri, 8 Jun 2012 16:26:49 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-m68k@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: remove six unused headers
References: <1339059427.25798.3.camel@x61.thuisdomein>
In-Reply-To: <1339059427.25798.3.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 07/06/12 18:57, Paul Bolle wrote:
> There are six entirely unused headers in arch/m68k/include/asm. Nothing
> includes these headers. And a few tests found no hits for the things
> they provide (which makes sense).
>
> MC68332.h, mac_mouse.h, mcfmbus.h, and mcfne.h are all unused since at
> least v2.6.12-rc2 (I didn't bother looking further back than that).

Although mcfne.h has been unused for a while I am working on some patches
that do use it. No problem for the others.


> apollodma.h is unused since v2.6.19: commit
> 2ed0ce5b57950a620155433c62a5a02a067f1376 ("m68k/Apollo: Remove obsolete
> arch/m68k/apollo/dma.c") removed the last file interested in that
> header.
>
> And everything interested in<asm/sbus.h>  was removed in the v2.6.28
> release cycle. The last occurrence of "sbus.h" was deleted with commit
> 0c0db98b50ed1217c0dbf4051722034ba314d06e ("sparc: Remove
> Documentation/sparc/sbus_drivers.txt"). I'm not sure whether anything
> relevant for m68k was included in v2.6.27, but it doesn't really matter.
>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>

Acked-by: Greg Ungerer<gerg@uclinux.org>

Regards
Greg



> ---
> Tested with "git grep" only. I haven't got the hardware nor the
> toolchain needed to do anything more thorough.
>
>   arch/m68k/include/asm/MC68332.h   |  152 -----------------------
>   arch/m68k/include/asm/apollodma.h |  248 -------------------------------------
>   arch/m68k/include/asm/mac_mouse.h |   23 ----
>   arch/m68k/include/asm/mcfmbus.h   |   77 ------------
>   arch/m68k/include/asm/mcfne.h     |  242 ------------------------------------
>   arch/m68k/include/asm/sbus.h      |   45 -------
>   6 files changed, 0 insertions(+), 787 deletions(-)
>   delete mode 100644 arch/m68k/include/asm/MC68332.h
>   delete mode 100644 arch/m68k/include/asm/apollodma.h
>   delete mode 100644 arch/m68k/include/asm/mac_mouse.h
>   delete mode 100644 arch/m68k/include/asm/mcfmbus.h
>   delete mode 100644 arch/m68k/include/asm/mcfne.h
>   delete mode 100644 arch/m68k/include/asm/sbus.h
>
-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
