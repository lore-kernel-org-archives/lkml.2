Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0JCL3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:29:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40281 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0JCL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:29:41 -0400
Date: Sun, 3 Oct 2010 12:29:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
Message-ID: <20101003112920.GB32736@n2100.arm.linux.org.uk>
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101003112312.GB9844@angua.secretlab.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 05:23:12AM -0600, Grant Likely wrote:
> On Thu, Sep 30, 2010 at 11:14:27PM -0000, Thomas Gleixner wrote:
> > The following patch series cleans up and mostly reimplements the core
> > sparse irq implementation and sanitizes the most complex (ab)user:
> > arch/x86
> 
> Hoy Thomas,
> 
> patches 1-13 & 15 all look fine to me.  Feel free to add my Acked-by:
> line.
> 
> Patch 14 seems to be missing, and by inference it appears that the
> all important new allocator is added by patch 14.  All of the rest of
> the series seems to be fine, but I'm forced to make assumptions about
> what the new allocator looks like, so I cannot be positive.

Patch 14 was present, you were even CC'd on it.
