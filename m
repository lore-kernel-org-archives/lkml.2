Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2H0RR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:17:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55022 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2H0RR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:17:26 -0400
Date: Mon, 27 Aug 2012 21:17:21 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC] x86: drop unnecessary kernel_eflags variable from 64 bit
Message-ID: <20120827171721.GC27096@moon>
References: <20120824195847.GA31628@moon>
 <20120827171438.GA17289@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827171438.GA17289@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 10:14:38AM -0700, Andi Kleen wrote:
> On Fri, Aug 24, 2012 at 11:58:47PM +0400, Cyrill Gorcunov wrote:
> > Hi guys,
> > 
> > I've been looking for some particular email in my mailbox when
> > found the patch below (it's dated as August 2011 ;) and think
> > it's still valid for kernel. Actually there were two patches,
> > and the second patch was unifying x86-32 with x86-64 but it
> > was doable as far as I remember.
> 
> Patch is fine for me. I did the original code, but you're right
> it's unlikely the EFLAGS will ever be extended.
> 
> Acked-by: Andi Kleen <ak@linux.intel.com>

Thanks for review, Andi!
