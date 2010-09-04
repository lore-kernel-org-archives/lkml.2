Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab0IDOcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:32:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54276 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0IDOcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:32:52 -0400
Date: Sat, 4 Sep 2010 15:32:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
Message-ID: <20100904143231.GB16462@n2100.arm.linux.org.uk>
References: <1282922978.5075.13.camel@m0nster> <1282925072.26355.61.camel@e102109-lin.cambridge.arm.com> <1282926826.5075.21.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282926826.5075.21.camel@m0nster>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 09:33:46AM -0700, Daniel Walker wrote:
> So your saying it makes more sense to change the msm entry into the
> default entry, and make the current default into the
> ARM11MPCore/Cortex-A9 entry?
> 
> There's 4 or 5 other cpu's that have SMP but none have had to jump over
> those bits AFAIK ..

What CPUs (CPU not SoC) are you referring to?

CPUs is the core that runs the code.  SoC is the CPU with the peripherals.
OMAP is not a CPU.  OMAP is a SoC.
