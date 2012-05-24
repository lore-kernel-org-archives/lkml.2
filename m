Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2EXJY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:24:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60243 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2EXJY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:24:28 -0400
Date: Thu, 24 May 2012 10:24:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: amba: remove NO_IRQ
Message-ID: <20120524092403.GA24149@n2100.arm.linux.org.uk>
References: <20120524091933.GA8566@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524091933.GA8566@mail.gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:19:33AM +0200, Alessandro Rubini wrote:
> I'm using PrimeCell devices under PCIe, x86 platform. We discussed
> this issue on Mar 1st, and you (Russell) reported that NO_IRQ is
> expected to go away for ARM, as 0 is the new official "no irq" marker.
> 
> The trivial patch below is what I'm currently using to compile my
> stuff, but I'd like to get an update about NO_IRQ in ARM (which you
> complained was completely on your shoulders). If needed I can take it
> over and propose patches.
> 
> I'm well aware that the few users within arch/arm are matched by a
> much bigger number of users in drivers/ .  The work is not trivial,
> but at least I hope to be able to remove NO_IRQ from amba/bus.c by
> auditing all its users.

See dfb85185bda373a70409c70c2632b02fb0f8f449 in mainline.
