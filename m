Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab0J0OeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380Ab0J0OeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:34:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTim80mTPKN7HFk0-H_C4xmg0ySt--gMX_L9_qQrc@mail.gmail.com>
References: <AANLkTim80mTPKN7HFk0-H_C4xmg0ySt--gMX_L9_qQrc@mail.gmail.com> <20101026025301.23512.24525.stgit@warthog.procyon.org.uk> <20101026025608.23512.60938.stgit@warthog.procyon.org.uk>
To: Suzuki Takashi <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Subject: Re: [Linux-am33-list] [PATCH 35/43] MN10300: And Panasonic AM34 subarch and implement SMP
Date: Wed, 27 Oct 2010 15:33:52 +0100
Message-ID: <32523.1288190032@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> >  arch/mn10300/proc-mn2ws0050/Makefile               |    5
> >  arch/mn10300/proc-mn2ws0050/include/proc/cache.h   |   48 +
> >  arch/mn10300/proc-mn2ws0050/include/proc/clock.h   |   20
> >  .../proc-mn2ws0050/include/proc/dmactl-regs.h      |  103 ++
> >  .../proc-mn2ws0050/include/proc/intctl-regs.h      |   29 +
> >  arch/mn10300/proc-mn2ws0050/include/proc/irq.h     |   49 +
> >  .../proc-mn2ws0050/include/proc/nand-regs.h        |  120 ++
> >  arch/mn10300/proc-mn2ws0050/include/proc/proc.h    |   18
> >  .../mn10300/proc-mn2ws0050/include/proc/smp-regs.h |   51 +
> >  arch/mn10300/proc-mn2ws0050/proc-init.c            |  134 ++
> 
> Are these specific to mn2ws0050 or common among AM34 based SoCs?

These are specific to the MN2WS0050 processor chip.  The MN2WS0050 is one
example of a chip that has one or more AM34 cores, plus a bunch of on-silicon
peripherals.

David
