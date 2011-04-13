Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab1DMSwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:52:47 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:51213 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab1DMSwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:52:46 -0400
Subject: Re: [GIT PULL] AVR32 fixes and minor updates for 2.6.39
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Andreas =?ISO-8859-1?Q?Bie=DFmann?= <andreas.devel@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        AVR32 Linux Kernel <kernel@avr32linux.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DA5AC40.9070307@gmail.com>
References: <1302702816.10549.7.camel@hcegtvedt>
	 <4DA5AC40.9070307@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 13 Apr 2011 16:02:16 +0200
Message-ID: <1302703336.10549.8.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Apr 2011 14:02:19.0100 (UTC) FILETIME=[66FDE9C0:01CBF9E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 15:59 +0200, Andreas Bießmann wrote: 
> Am 13.04.2011 15:53, schrieb Hans-Christian Egtvedt:
> > Jean-Christophe PLAGNIOL-VILLARD (1):
> >       avr32: At32ap: pio fix typo "))" on gpio_irq_unmask prototype
> 
> You may have missed
> 
> Jean-Christophe PLAGNIOL-VILLARD:
> 	avr32: At32ap: fix extint irq_chip type from irq_chip to irq_data
> 
> It is required for extint.c to compile.

Fixed by

Wanlong Gao (1):
      fix the wrong argument of the functions definition

Which was pulled in by Andrew.

-- 
Hans-Christian Egtvedt

