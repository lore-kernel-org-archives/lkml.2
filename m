Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0EUOwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:52:42 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50691 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab0EUOwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:52:40 -0400
Date: Fri, 21 May 2010 23:52:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-sh@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: bkl: Pushdowns for sound/oss ?
Message-ID: <20100521145236.GA15948@linux-sh.org>
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain> <20100521144055.GB13174@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521144055.GB13174@linux-mips.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:40:56PM +0100, Ralf Baechle wrote:
> On Fri, May 21, 2010 at 03:45:04PM +0200, John Kacur wrote:
> > sound/oss/sh_dac_audio.c
> 
> SH3 specific.
> 
This has since been replaced with an ALSA driver, so we can basically
just kill the OSS driver off at this point. I was going to kill it off
before, but wanted to give people some time to test out the new driver.
