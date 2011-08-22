Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1HVP2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab1HVP2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:28:47 -0400
Date: Mon, 22 Aug 2011 11:28:39 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 6/6] x86, nmi: print out NMI stats in
 /proc/interrupts
Message-ID: <20110822152839.GE2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-7-git-send-email-dzickus@redhat.com>
 <1314023262.24275.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314023262.24275.38.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:27:42PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> > NMI:       4161       4155        158       4194   Non-maskable interrupts
> > SWA:          0          0          0          0   Unknown NMIs swallowed
> >   0:       4161       4155        158       4194   NMI  PMI, arch_bt
> > UNK:          0          0          0          0   NMI
> > EXT:          0          0          0          0   NMI 
> 
> Yeah, not too pretty.. I would have expected something like:
> 
> NMI:
>  PMI:
>  uv:
>  arch_bt:
>  ...
>  swallowed:
>  unknown:

Yeah, I kinda wanted to do that originally, but wasn't sure what the rules
were for the output structure of that file.  I even toyed with the idea of
creating a /proc/nmi file to do that too, but thought that it might confuse
people.

> 
> But then, I'm sure some people would complain to that as I'm pretty sure
> it'll break stuff parsing /proc/interrupts

That's why I just posted my half-ass patch to see if it was

- useful info
- gather ideas on the best way to present it

Cheers,
Don

