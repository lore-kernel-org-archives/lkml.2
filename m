Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1ISWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:42:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40778 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1ISWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:42:18 -0400
Date: Mon, 19 Sep 2011 23:41:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: debug: Add CLSP711X_UART1 config choice
Message-ID: <20110919224151.GB28237@n2100.arm.linux.org.uk>
References: <20110916114140.GA31334@e102144-lin.cambridge.arm.com> <1316455300-5752-1-git-send-email-sboyd@codeaurora.org> <20110919212502.GB23613@e102144-lin.cambridge.arm.com> <4E77BE34.6070702@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E77BE34.6070702@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 03:12:04PM -0700, Stephen Boyd wrote:
> On 09/19/11 14:25, Will Deacon wrote:
> > Thanks for cooking the patch, it was somewhere on my list of things to do
> > this week! I think we also need to fix the DEBUG_DC21285_PORT option as that
> > has a similar `if not selected then use a different UART' behaviour. It can be
> > fixed in the same way as you have done in this patch.'
> 
> Ah my eyes glossed over the DC21285 one. Here's one on top of patch 2.
> Feel free to squash, etc.

Err, the DC21285 only has one serial port.

Some footbridge platforms expose the DC21285 to the outside world, others
don't.  Some footbridge platforms have a separate 8250 UART at the standard
PCI COM1 address, others don't.

What DEBUG_DC21285_PORT is selecting between is whether to use the DC21285
port (when set) or the 8250 at PCI COM1 (when unset).
