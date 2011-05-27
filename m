Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab1E0UNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:13:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37950 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1E0UNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:13:48 -0400
Date: Fri, 27 May 2011 14:13:45 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 3/6] MIPS: Octeon: Add device tree source files.
Message-ID: <20110527201345.GC6645@ponder.secretlab.ca>
References: <1305930343-31259-1-git-send-email-ddaney@caviumnetworks.com>
 <1305930343-31259-4-git-send-email-ddaney@caviumnetworks.com>
 <20110527015618.GC5032@ponder.secretlab.ca>
 <4DDFD892.1040309@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFD892.1040309@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:00:02AM -0700, David Daney wrote:
> On 05/26/2011 06:56 PM, Grant Likely wrote:
> >>+- #interrupt-cells: Must be<2>.  The first cell is the GPIO pin
> >>+   connected to the interrupt source.  The second cell is the interrupt
> >>+   triggering protocol and may have one of four values:
> >>+   0 - level triggered active high.
> >>+   1 - level triggered active low
> >>+   2 - edge triggered on the rising edge.
> >>+   3 - edge triggered on the falling edge.
> >
> >Since you're choosing arbitrary values here anyway, it's convenient to
> >follow the lead of include/linux/irq.h and using 1->edge rising,
> >2->edge falling, 4->level high, 8->level low.  In the past every irq
> >controller kind of did it's own thing, but that's not very scalable.
> >
> 
> OK.  I will use those still somewhat arbitrary values instead.

Indeed, they are still completely arbitrary, but at least they are the
same completely arbitrary values.  :-)

g.

