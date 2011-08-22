Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1HVN76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:59:58 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59816 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1HVN74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:59:56 -0400
Date: Mon, 22 Aug 2011 14:59:52 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: vexpress: Use wfi macro in platform_do_lowpower.
Message-ID: <20110822135952.GE2796@pulham.picochip.com>
References: <CAHkRjk6Fq+1b_uM+DFACS1QVd7B6_1XhqRw-27i88U1VyvLk+Q@mail.gmail.com>
 <1314021259-31710-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314021259-31710-1-git-send-email-nbowler@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 09:54:19AM -0400, Nick Bowler wrote:
> Current Versatile Express CPU hotplug code includes a hardcoded WFI
> instruction, in ARM encoding.  When the kernel is compiled in Thumb-2
> mode, this is invalid and causes the machine to hang hard when a CPU
> is offlined.
> 
> Using the wfi macro (which uses the appropriate assembler mnemonic)
> causes the correct instruction to be emitted in either case.  As a
> consequence of this change, an apparently vestigial "cc" clobber is
> dropped from the asm (the macro uses "memory" only).
> 
> Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
> ---

Reviewed-by: Jamie Iles <jamie@jamieiles.com>

if it helps!

Jamie
