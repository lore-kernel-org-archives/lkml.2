Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1ASWF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:05:27 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47579 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab1ASWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:05:25 -0500
Subject: Re: [patch 32/37] parisc: Use generic irq Kconfig
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <20110119210840.424269590@linutronix.de>
References: <20110119205258.462759212@linutronix.de>
	 <20110119210840.424269590@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 16:05:22 -0600
Message-ID: <1295474722.10978.43.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 21:49 +0000, Thomas Gleixner wrote:
> plain text document attachment (parisc-use-generic-irq-Kconfig.patch)
> No functional change.

Not quite true ... you take out GENERIC_HARDIRQS but select
HAVE_GENERIC_HARDIRQS ... is that right?

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kyle McMartin <kyle@mcmartin.ca>

Plus, it doesn't apply:

Hunk #1 FAILED at 12.
Hunk #2 FAILED at 65.
2 out of 2 hunks FAILED -- saving rejects to file
arch/parisc/Kconfig.rej

It looks like it was made before we did our generic irq conversion in
the 2.6.36 merge window.

James


