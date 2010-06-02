Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab0FBXk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:40:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933289Ab0FBXkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:40:25 -0400
Date: Wed, 2 Jun 2010 16:38:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-pcmcia@lists.infradead.org, linux@arm.linux.org.uk,
       mad_soft@inbox.ru, rpjday@crashcourse.ca, jaswinderrajput@gmail.com,
       kristoffer.ericson@gmail.com,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: Pull request for nanoengine
Message-Id: <20100602163844.509e9953.akpm@linux-foundation.org>
In-Reply-To: <AANLkTilh4NtHS5p3tWbMtIU9MBBC-Md13Aw9_RdL3Ogp@mail.gmail.com>
References: <AANLkTilh4NtHS5p3tWbMtIU9MBBC-Md13Aw9_RdL3Ogp@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 20:19:01 -0300
Marcelo Roberto Jimenez <mroberto@cetuc.puc-rio.br> wrote:

> The following is a compilation of all the patches I have done for the
> nanoengine. Some of these are also valid for SA11xx based machines
> like, e.g, sharp Zaurus.

Which other kernel developer were you hoping would merge this tree?

>  arch/arm/configs/nanoengine_defconfig          | 1396 ++++++++++++++++++++++++
>  arch/arm/mach-sa1100/Kconfig                   |    8 +
>  arch/arm/mach-sa1100/Makefile                  |    2 +
>  arch/arm/mach-sa1100/cpu-sa1100.c              |   56 +-
>  arch/arm/mach-sa1100/cpu-sa1110.c              |   51 +-
>  arch/arm/mach-sa1100/include/mach/nanoengine.h |   30 +
>  arch/arm/mach-sa1100/nanoengine.c              |  115 ++
>  drivers/pcmcia/Makefile                        |    3 +-
>  drivers/pcmcia/sa1100_generic.c                |    3 +
>  drivers/pcmcia/sa1100_generic.h                |    1 +
>  drivers/pcmcia/sa1100_nanoengine.c             |  219 ++++
>  drivers/pcmcia/soc_common.c                    |  129 ++-
>  drivers/rtc/rtc-sa1100.c                       |  153 ++-

I can only think it must have been Russell.

I've rather lost track of what's happening with ARM subtrees.  I
_think_ it's now the case the relevant maintainers are putting their
trees into linux-next directly and are asking Linus to pull them
directly.  But maybe that's a misconception.

Can someone please explain the current state of play?

Thanks.
