Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0HDEnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:43:50 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60955 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0HDEns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:43:48 -0400
Date: Wed, 4 Aug 2010 10:13:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        hschauhan@nulltrace.org
Subject: Re: [PATCH 0/5] KProbes support for MIPS
Message-ID: <20100804044335.GA23536@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:22:17AM -0700, David Daney wrote:
> This patch set adds KProbs, JProbs and KRetProbes support for the MIPS
> archetecture.
> 
> It was tested on a 64-bit big-endian kernel (Octeon), but should work
> equally well on 32-bit and little-endian as well.
> 
> As you can see from the patches it is partially based on previous work
> by Sony and Himanshu Chauhan.
> 
> David Daney (5):
>   MIPS: Define regs_return_value()
>   MIPS: Add instrunction format for BREAK and SYSCALL
>   MIPS: Add KProbe support.
>   samples: kprobe_example: Make it print something on MIPS.
>   documentation: Mention that KProbes is supported on MIPS

David,

Thanks for the port!

I do not know enough about MIPS internals to be able to review the
arcane architecture specific details in the implementation.

It would help if you add yourself to the MAINTAINERS list for the MIPS
port. If people hit an issue, they'll know to cc you.

Ananth
