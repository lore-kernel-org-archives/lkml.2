Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0CZGNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:13:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55114 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0CZGNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:13:12 -0400
Date: Fri, 26 Mar 2010 07:13:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [patch 1/2] genirq: Run irq handlers with interrupts disabled
Message-ID: <20100326061310.GV20695@one.firstfloor.org>
References: <20100326000325.917127328@linutronix.de> <20100326000405.758579387@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326000405.758579387@linutronix.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Drivers for whacky hardware still can reenable them in the handler
> itself, if the need arises. (They do already due to lockdep)

Can you please explain that lockdep reference?
I don't think lockdep really forces on interrupts, does it?

BTW the one problem I have with this patchkit is that it's clearly
no stable candidate and I was hoping for a stable fix too.
Any chance to at least approve my original patch for .32/.33 only?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
