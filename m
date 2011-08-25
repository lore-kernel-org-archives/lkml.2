Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1HYEa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:30:59 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43717 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1HYEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:30:56 -0400
X-Sasl-enc: ywrz1WeLTgRXNHisj/cXaGmbsy2u4al+OJeV43+KVoXw 1314246655
Subject: Re: [PATCH v2 00/43] signal: set_current_blocked() and
 block_sigmask()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>,
        Petr Vandrovec <petr@vandrovec.name>
In-Reply-To: <20110824182411.GA30094@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <20110824182411.GA30094@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 12:30:50 +0800
Message-ID: <1314246650.3218.3.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 20:24 +0200, Oleg Nesterov wrote:
> (add linux-arch)
> 
> On 08/19, Matt Fleming wrote:
> >
> >  arch/alpha/kernel/signal.c         |   31 ++++++++----------------
> >  arch/arm/kernel/signal.c           |   24 ++++++------------
> >  arch/avr32/kernel/signal.c         |   26 ++++++--------------
> >  arch/blackfin/kernel/signal.c      |   17 +++----------
> >  arch/cris/arch-v10/kernel/signal.c |   34 +++++++++-----------------
> >  arch/cris/arch-v32/kernel/signal.c |   37 ++++++++--------------------
> >  arch/frv/kernel/signal.c           |   32 ++++++++-----------------
> >  arch/h8300/kernel/signal.c         |   33 +++++++-------------------
> >  arch/ia64/kernel/signal.c          |   15 +----------
> >  arch/m32r/kernel/signal.c          |   12 +--------
> >  arch/m68k/kernel/signal_mm.c       |   22 +++++++----------
> >  arch/m68k/kernel/signal_no.c       |   28 +++++++---------------
> >  arch/microblaze/kernel/signal.c    |   42 +++++++++++++--------------------
> >  arch/mips/kernel/signal.c          |   27 ++++-----------------
> >  arch/mips/kernel/signal32.c        |   20 +++------------
> >  arch/mips/kernel/signal_n32.c      |   10 +------
> >  arch/mn10300/kernel/signal.c       |   32 ++++++++-----------------
> >  arch/openrisc/kernel/signal.c      |   45 +++++++++++++++--------------------
> >  arch/parisc/kernel/signal.c        |   12 +--------
> >  arch/powerpc/kernel/signal.c       |   13 +--------
> >  arch/powerpc/kernel/signal_32.c    |   11 ++++----
> >  arch/s390/kernel/compat_signal.c   |    6 +----
> >  arch/s390/kernel/signal.c          |    6 +----
> >  arch/score/kernel/signal.c         |   13 ++--------
> >  arch/sh/kernel/signal_32.c         |   35 ++++++++--------------------
> >  arch/sh/kernel/signal_64.c         |   40 ++++++++------------------------
> >  arch/sparc/kernel/signal32.c       |   17 ++-----------
> >  arch/sparc/kernel/signal_32.c      |   28 +++++++---------------
> >  arch/sparc/kernel/signal_64.c      |   29 ++++++++---------------
> >  arch/tile/kernel/compat_signal.c   |    5 +---
> >  arch/tile/kernel/signal.c          |   13 +--------
> >  arch/um/kernel/signal.c            |   28 +++++++---------------
> >  arch/um/sys-i386/signal.c          |   12 +--------
> >  arch/um/sys-x86_64/signal.c        |    6 +----
> >  arch/unicore32/kernel/signal.c     |   13 +--------
> >  arch/x86/kernel/signal.c           |    6 +----
> >  arch/xtensa/kernel/signal.c        |   35 ++++++++-------------------
> >  fs/autofs4/waitq.c                 |   13 +++-------
> >  fs/coda/upcall.c                   |   19 ++++++--------
> >  fs/dlm/user.c                      |    1 -
> >  fs/ncpfs/sock.c                    |   15 ++++--------
> >  include/linux/signal.h             |    1 +
> >  kernel/signal.c                    |   21 ++++++++++++++++
> 
> Thanks to those who replied.
> 
> I applied the whole series with a few acks we got. Other maintainers
> do not care, I guess.

I wouldn't say that, I didn't NAK it for autofs4.
I do appreciate the cc on the post, thanks.

Ian


