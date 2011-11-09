Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab1KIAYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:24:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50421 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536Ab1KIAYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:24:46 -0500
Date: Wed, 9 Nov 2011 00:24:37 +0000
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 15/16] ARM: LPAE: add support for ATAG_MEM64
Message-ID: <20111109002437.GA5256@mudshark.cambridge.arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
 <alpine.LFD.2.02.1111081832290.3307@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111081832290.3307@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Tue, Nov 08, 2011 at 11:38:12PM +0000, Nicolas Pitre wrote:
> On Mon, 7 Nov 2011, Catalin Marinas wrote:
> 
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > LPAE provides support for memory banks with physical addresses of up
> > to 40 bits.
> > 
> > This patch adds a new atag, ATAG_MEM64, so that the Kernel can be
> > informed about memory that exists above the 4GB boundary.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> NAK.  Any LPAE capable platform to come is, by definition, a new 
> platform.  It therefore should be using DT upfront.

Ok, well in that case it's a simple matter of defining #address-cells
correctly in your .dts and we can simply drop this patch. Does that sound
like the right approach?

Will
