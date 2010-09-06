Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0IFWW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 18:22:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0IFWWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 18:22:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6097"; a="53431600"
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <20100904143231.GB16462@n2100.arm.linux.org.uk>
References: <1282922978.5075.13.camel@m0nster>
	 <1282925072.26355.61.camel@e102109-lin.cambridge.arm.com>
	 <1282926826.5075.21.camel@m0nster>
	 <20100904143231.GB16462@n2100.arm.linux.org.uk>
Content-Type: text/plain
Date: Mon, 06 Sep 2010 15:22:14 -0700
Message-Id: <1283811734.16225.240.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-04 at 15:32 +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 27, 2010 at 09:33:46AM -0700, Daniel Walker wrote:
> > So your saying it makes more sense to change the msm entry into the
> > default entry, and make the current default into the
> > ARM11MPCore/Cortex-A9 entry?
> > 
> > There's 4 or 5 other cpu's that have SMP but none have had to jump over
> > those bits AFAIK ..
> 
> What CPUs (CPU not SoC) are you referring to?
> 
> CPUs is the core that runs the code.  SoC is the CPU with the peripherals.
> OMAP is not a CPU.  OMAP is a SoC.

I guess I'm referring to the SoC then (in this case all SMP SoC's) .. 

Daniel

