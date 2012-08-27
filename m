Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2H0ROn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:14:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:49381 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab2H0ROm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:14:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,321,1344236400"; 
   d="scan'208";a="185421330"
Date: Mon, 27 Aug 2012 10:14:38 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC] x86: drop unnecessary kernel_eflags variable from 64 bit
Message-ID: <20120827171438.GA17289@tassilo.jf.intel.com>
References: <20120824195847.GA31628@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824195847.GA31628@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:58:47PM +0400, Cyrill Gorcunov wrote:
> Hi guys,
> 
> I've been looking for some particular email in my mailbox when
> found the patch below (it's dated as August 2011 ;) and think
> it's still valid for kernel. Actually there were two patches,
> and the second patch was unifying x86-32 with x86-64 but it
> was doable as far as I remember.

Patch is fine for me. I did the original code, but you're right
it's unlikely the EFLAGS will ever be extended.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
