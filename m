Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab0EUPmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:42:22 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:38659 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933492Ab0EUPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:42:20 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2010 11:42:20 EDT
Message-ID: <4BF6A7A6.9080807@ladisch.de>
Date: Fri, 21 May 2010 17:32:54 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, Krzysztof Helt <krzysztof.h1@wp.pl>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: bkl: Pushdowns for sound/oss ?
References: <alpine.LFD.2.00.1005211536330.25348@localhost.localdomain> <20100521144055.GB13174@linux-mips.org>
In-Reply-To: <20100521144055.GB13174@linux-mips.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> On Fri, May 21, 2010 at 03:45:04PM +0200, John Kacur wrote:
> > sound/oss/msnd_pinnacle.c
> 
> Random weirdo ISA sound card.  Probably only ever tested on x86 and will
> have the chances

This has since been replaced with an ALSA driver, so we can basically
just kill the OSS driver off at this point.  Krzystof?
