Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810Ab2KASkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:40:09 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:4988 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2KASkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:40:05 -0400
Date: Thu, 1 Nov 2012 14:39:21 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH v2] ARM: zynq: Allow UART1 to be used as DEBUG_LL console.
Message-ID: <20121101183921.GA32744@elliptictech.com>
References: <1351534769-22155-1-git-send-email-nbowler@elliptictech.com>
 <508FB9B1.5060404@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508FB9B1.5060404@monstr.eu>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-30 12:27 +0100, Michal Simek wrote:
> On 10/29/2012 07:19 PM, Nick Bowler wrote:
> > +#if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
> > +#	define LL_UART_PADDR	UART1_PHYS
> > +#	define LL_UART_VADDR	UART_VIRT
> > +#else
> > +#	define LL_UART_PADDR	UART0_PHYS
> > +#	define LL_UART_VADDR	UART_VIRT
> > +#endif
> 
> Probably no reason to setup LL_UART_VADDR on two lines.
> It is enough to set it up once.
> 
> MINOR: It is just my personal preference to use different coding style.
> 
> #if IS_ENABLED(CONFIG_DEBUG_ZYNQ_UART1)
> # define LL_UART_PADDR	UART1_PHYS
> #else
> # define LL_UART_PADDR	UART0_PHYS
> #endif
> 
> #define LL_UART_VADDR	UART_VIRT

I have no strong feeling either way, so I will send v3 with these
changes.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
