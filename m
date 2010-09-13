Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0IMMvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:51:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40731 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab0IMMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:51:48 -0400
Date: Mon, 13 Sep 2010 13:51:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Theunis <robint91@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ARM target not boot after remap memory
Message-ID: <20100913125140.GH30787@n2100.arm.linux.org.uk>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com> <4C8E1417.4060204@compulab.co.il> <20100913124049.GG30787@n2100.arm.linux.org.uk> <AANLkTi=dT1uMrRctB4=Hvh35zVc-DtReWmHj-18cd9XT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=dT1uMrRctB4=Hvh35zVc-DtReWmHj-18cd9XT@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 02:48:18PM +0200, Robin Theunis wrote:
> Hi Russell,
> 
> Yes I have tested it. I made a breakpoint at 0x2008000 and viewed that
> the r1 register and there in I found the correct ID.

Ensure that CONFIG_DEBUG_LL is enabled, and that it outputs to the correct
UART.  The kernel will produce some messages via the DEBUG_LL stuff prior
to entering the __error loop.
