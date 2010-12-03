Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0LCPlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:41:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38491 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0LCPlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:41:14 -0500
Date: Fri, 3 Dec 2010 16:41:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Robin Holt <holt@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: Do we need to call calibrate_delay() for all
 cores/hyperthreads on a socket?
Message-ID: <20101203154109.GC8800@basil.fritz.box>
References: <20101203065212.GQ6858@sgi.com>
 <20101203093617.GB8800@basil.fritz.box>
 <20101203150928.GG3344@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203150928.GG3344@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If, on the other hand, we do it per core, it ends up only reducing boot
> time by 121 seconds.  An improvement for sure, but not good enough to
> make me really happy ;).

If you parallelize it you can be even faster.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
