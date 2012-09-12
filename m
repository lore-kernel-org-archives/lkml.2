Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2ILUmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:42:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44033 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2ILUmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:42:09 -0400
Date: Wed, 12 Sep 2012 16:42:06 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com
Subject: Re: [PATCH v9 00/13] Per sub-architecture SMP operations
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1209121635560.28681@xanadu.home>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Arnd Bergmann wrote:

> As I promised at the ARM mini summit, I've updated Marc's series
> for smp operations according to my complaints. Unfortunately,
> I could not find version 7 of the patches when I started this,
> so I based my work on version 6 and had to redo the same
> changes.
> 
> The patches are also available on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git testing/smp_ops

There are still minor details nagging me, although I did mention them in 
my previous review of this series.  You might have disagreed if I 
remember correctly.  They aren't fundamental, and my insisting on them 
would only be bikeshedding at this point. Therefore you can add my ACK.

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
