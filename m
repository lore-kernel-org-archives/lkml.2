Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1KIKoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:44:22 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46759 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786Ab1KIKoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:44:21 -0500
Date: Wed, 9 Nov 2011 10:44:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v8 15/16] ARM: LPAE: add support for ATAG_MEM64
Message-ID: <20111109104401.GB31092@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-16-git-send-email-catalin.marinas@arm.com>
 <alpine.LFD.2.02.1111081832290.3307@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1111081832290.3307@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

It's fine by me, one less patch to merge.

-- 
Catalin
