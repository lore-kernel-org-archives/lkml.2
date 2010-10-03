Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0JCNtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:49:12 -0400
Received: from www.tglx.de ([62.245.132.106]:56665 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab0JCNtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:49:10 -0400
Date: Sun, 3 Oct 2010 15:48:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1081961718-1286113700=:14550"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1081961718-1286113700=:14550
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 3 Oct 2010, Grant Likely wrote:

> On Sun, Oct 3, 2010 at 5:29 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Sun, Oct 03, 2010 at 05:23:12AM -0600, Grant Likely wrote:
> >> On Thu, Sep 30, 2010 at 11:14:27PM -0000, Thomas Gleixner wrote:
> >> > The following patch series cleans up and mostly reimplements the core
> >> > sparse irq implementation and sanitizes the most complex (ab)user:
> >> > arch/x86
> >>
> >> Hoy Thomas,
> >>
> >> patches 1-13 & 15 all look fine to me.  Feel free to add my Acked-by:
> >> line.
> >>
> >> Patch 14 seems to be missing, and by inference it appears that the
> >> all important new allocator is added by patch 14.  All of the rest of
> >> the series seems to be fine, but I'm forced to make assumptions about
> >> what the new allocator looks like, so I cannot be positive.
> >
> > Patch 14 was present, you were even CC'd on it.
> 
> Hmmm... found it now.  I'm not sure what happened there, but I
> couldn't find it the first time I looked.  Most likely it is a PEBKAC
> failure.  Sorry for the noise.
> 
> Okay, patch 14 looks good to me too (including Yinghai's comment).
> The new allocator seems sane, and I didn't see any obvious errors in
> patches 16-47.  I've not tested any of this yet.  Hopefully I'll be
> able to carve out some time to do so early this week.

Wait until I pushed out a fixed tree. In meantime I found out how I
managed to screw up the quilt series :(

Will post, once it's ready.

Thanks,

	tglx
---1463795968-1081961718-1286113700=:14550--
