Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0JNMM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:12:28 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38206 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0JNMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:12:26 -0400
Date: Thu, 14 Oct 2010 14:12:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        akpm <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] bitops.h: Widen BIT macro to support 64-bit types
Message-ID: <20101014121230.GC31247@aftab>
References: <20101013131057.88238be6.randy.dunlap@oracle.com>
 <20101014042409.GB29342@aftab>
 <20101014105855.GB31247@aftab>
 <20101014111213.GO10421@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014111213.GO10421@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Thu, Oct 14, 2010 at 07:12:13AM -0400

> On Thu, Oct 14, 2010 at 12:58:55PM +0200, Borislav Petkov wrote:
> >  #ifdef	__KERNEL__
> > -#define BIT(nr)			(1UL << (nr))
> > +#define BIT(nr)			(U64_C(1) << (nr))
> 
> Why not just use 1ULL instead?

Wanted to be __ASSEMBLY__ safe.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
