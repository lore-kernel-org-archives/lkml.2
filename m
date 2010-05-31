Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0EaJrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:47:08 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:42813 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0EaJrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:47:06 -0400
Date: Mon, 31 May 2010 11:46:52 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mikael.starvik@axis.com, jesper.nilsson@axis.com
Subject: Re: Linux 2.6.35-rc1
Message-ID: <20100531094652.GI5051@axis.com>
References: <alpine.LFD.2.00.1005301356350.3986@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005301356350.3986@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 11:11:09PM +0200, Linus Torvalds wrote:
> It's been two weeks, and so the merge window is closed. There may be a few 
> trees I haven't pulled yet, but the bulk should all be there. And please, 
> let's try to make the merge window mean something this time - don't send 
> me any new pull request unless they are for real regressions or for major 
> bugs, ok?

I'm missing the CRIS tree changes, however, it seems to be me that
screwed up here, my new computer was misconfigured for outgoing mail, so the
request probably never reached you. Sorry about that.

Of the changes, the "mask_irq" one is still a candidate since it
fixes a compile error.


The following changes since commit 1d16b0f2f3edf05f12a9e3960588e0d4854157bb:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../lrg/voltage-2.6

are available in the git repository at:

  git://www.jni.nu/cris.git for-linus

Arnd Bergmann (1):
      cris: push down BKL into some device drivers

Jesper Nilsson (6):
      CRISv32: Remove duplicated Kconfig items.
      CRISv32: Fix RS485 port 4 CD Kconfig item.
      CRISv10: Trivial fixes.
      CRISv10: Whitespace fixes for hw_settings.S
      CRIS: Simplify param.h by simply including <asm-generic/param.h>
      CRIS: Don't use mask_irq as symbol name

 arch/cris/arch-v10/drivers/ds1302.c   |   20 +++++++++++++++-----
 arch/cris/arch-v10/drivers/pcf8563.c  |   19 +++++++++++++++----
 arch/cris/arch-v10/kernel/irq.c       |    8 ++++----
 arch/cris/arch-v10/lib/dmacopy.c      |   15 +++++++--------
 arch/cris/arch-v10/lib/hw_settings.S  |   14 ++++++--------
 arch/cris/arch-v32/drivers/Kconfig    |   16 +---------------
 arch/cris/arch-v32/drivers/i2c.c      |   22 ++++++++++++++--------
 arch/cris/arch-v32/drivers/pcf8563.c  |   21 ++++++++++++++++-----
 arch/cris/arch-v32/kernel/crisksyms.c |    4 ++--
 arch/cris/arch-v32/kernel/irq.c       |   14 ++++++--------
 arch/cris/arch-v32/kernel/smp.c       |    4 ++--
 arch/cris/include/arch-v10/arch/irq.h |    9 +++++----
 arch/cris/include/arch-v32/arch/irq.h |    4 ++--
 arch/cris/include/asm/param.h         |   17 ++---------------
 14 files changed, 97 insertions(+), 90 deletions(-)

> 			Linus

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
