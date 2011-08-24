Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1HXRwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:52:13 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:42566 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1HXRwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:52:11 -0400
Date: Wed, 24 Aug 2011 13:51:55 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: vexpress: Use wfi macro in platform_do_lowpower.
Message-ID: <20110824175155.GA13380@elliptictech.com>
References: <CAHkRjk6Fq+1b_uM+DFACS1QVd7B6_1XhqRw-27i88U1VyvLk+Q@mail.gmail.com>
 <1314021259-31710-1-git-send-email-nbowler@elliptictech.com>
 <20110822135952.GE2796@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822135952.GE2796@pulham.picochip.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-22 14:59 +0100, Jamie Iles wrote:
> On Mon, Aug 22, 2011 at 09:54:19AM -0400, Nick Bowler wrote:
> > Current Versatile Express CPU hotplug code includes a hardcoded WFI
> > instruction, in ARM encoding.  When the kernel is compiled in Thumb-2
> > mode, this is invalid and causes the machine to hang hard when a CPU
> > is offlined.
> > 
> > Using the wfi macro (which uses the appropriate assembler mnemonic)
> > causes the correct instruction to be emitted in either case.  As a
> > consequence of this change, an apparently vestigial "cc" clobber is
> > dropped from the asm (the macro uses "memory" only).
> > 
> > Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> > ---
> 
> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> 
> if it helps!

Thanks!

Since there seem to be no objections, I'll send this off to Russell's
tracker.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
