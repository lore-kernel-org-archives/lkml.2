Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0DUC2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:28:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42397
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403Ab0DUC2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:28:47 -0400
Date: Tue, 20 Apr 2010 19:28:51 -0700 (PDT)
Message-Id: <20100420.192851.267086166.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: tglx@linutronix.de, arjan@linux.jf.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC: linux-next 1/2] irq: Add CPU mask affinity hint
 callback framework
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100419045741.30276.23233.stgit@ppwaskie-hc2.jf.intel.com>
References: <20100419045741.30276.23233.stgit@ppwaskie-hc2.jf.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Date: Sun, 18 Apr 2010 21:57:41 -0700

> This patch adds a callback function pointer to the irq_desc
> structure, along with a registration function and a read-only
> proc entry for each interrupt.
> 
> This affinity_hint handle for each interrupt can be used by
> underlying drivers that need a better mechanism to control
> interrupt affinity.  The underlying driver can register a
> callback for the interrupt, which will allow the driver to
> provide the CPU mask for the interrupt to anything that
> requests it.  The intent is to extend the userspace daemon,
> irqbalance, to help hint to it a preferred CPU mask to balance
> the interrupt into.
> 
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>

I'll leave it to the IRQ layer experts whether this is
appropriate or not, it doesn't look too bad to me.
