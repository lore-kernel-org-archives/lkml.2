Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1ASXV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:21:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab1ASXVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:21:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110119210840.041837065@linutronix.de>
References: <20110119210840.041837065@linutronix.de> <20110119205258.462759212@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Richard Henderson <rth@twiddle.net>,
        Mike Frysinger <vapier@gentoo.org>, Tony Luck <tony.luck@intel.com>,
        Greg Ungerer <gerg@uclinux.org>, Michal Simek <monstr@monstr.eu>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 24/37] genirq: Remove __do_IRQ
Date: Wed, 19 Jan 2011 23:19:18 +0000
Message-ID: <10507.1295479158@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> All architectures are finally converted. Remove the cruft.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Jeff Dike <jdike@addtoit.com>

Finally!

Acked-by: David Howells <dhowells@redhat.com>
