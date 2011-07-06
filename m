Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1GFXSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:18:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:16464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1GFXSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,489,1304319600"; 
   d="scan'208";a="22376506"
Date: Wed, 6 Jul 2011 16:17:11 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from 64
 bit.
Message-ID: <20110706231711.GA11595@tassilo.jf.intel.com>
References: <20110705111525.GR17941@sun>
 <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
 <CAOJsxLFjdrrnx4gZjDJQuf3GBHeKvKb91TajYBkMu+PgSWtM5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFjdrrnx4gZjDJQuf3GBHeKvKb91TajYBkMu+PgSWtM5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well lets ask Linus and Andi?

The original idea was that if someone extends EFLAGS with new bits
the BIOS could set them.  Strictly said the Intel Manual 
specifies that ("reserved bits -- always set to values previously read")
 
But that never really worked out and I don't think anyone
would dare extending it now.  So hardcoding is fine I guess.

-Andi
