Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2HUJv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:51:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40654 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817Ab2HUJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:51:27 -0400
Date: Tue, 21 Aug 2012 10:50:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 08/31] arm64: CPU support
Message-ID: <20120821095051.GA12708@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <20120815001043.GD19607@quad.lixom.net>
 <20120820155740.GA912@arm.com>
 <201208202047.07991.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208202047.07991.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 09:47:07PM +0100, Arnd Bergmann wrote:
> On Monday 20 August 2012, Catalin Marinas wrote:
> > > > --- /dev/null
> > > > +++ b/arch/arm64/mm/proc-syms.c
> > ...
> > > > +EXPORT_SYMBOL(__cpuc_flush_kern_all);
> > > > +EXPORT_SYMBOL(__cpuc_flush_user_all);
> > > > +EXPORT_SYMBOL(__cpuc_flush_user_range);
> > > > +EXPORT_SYMBOL(__cpuc_coherent_kern_range);
> > > > +EXPORT_SYMBOL(__cpuc_flush_dcache_area);
> > > 
> > > See comment on other email about putting function pointers in a struct
> > > instead.
> > 
> > There is no need to support multiple CPU architectures with different
> > implementations, so allowing these functions to be called without
> > indirection is better.
> 
> What is the __cpuc prefix about then? Could you just drop it?

It can be dropped indeed.

-- 
Catalin
