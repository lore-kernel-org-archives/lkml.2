Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1BONhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:37:17 -0500
Received: from service87.mimecast.com ([94.185.240.25]:46738 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753293Ab1BONhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:37:14 -0500
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
 unsigned long for physical addresses
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1297773569.14691.36.camel@e102109-lin.cambridge.arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
	 <20110212102803.GC15616@n2100.arm.linux.org.uk>
	 <1297770742.21448.2.camel@e102144-lin.cambridge.arm.com>
	 <20110215123522.GH4152@n2100.arm.linux.org.uk>
	 <1297773569.14691.36.camel@e102109-lin.cambridge.arm.com>
Date: Tue, 15 Feb 2011 13:37:07 +0000
Message-ID: <1297777027.1293.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 15 Feb 2011 13:37:10.0686 (UTC) FILETIME=[725C73E0:01CBCD15]
X-MC-Unique: 111021513371104601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 12:39 +0000, Catalin Marinas wrote:
> On Tue, 2011-02-15 at 12:35 +0000, Russell King - ARM Linux wrote:
> > On Tue, Feb 15, 2011 at 11:52:22AM +0000, Will Deacon wrote:
> > > Excellent! I've split the patch up into four distinct parts, as per your
> > > suggestions. I've submitted these to your patch system (6670/1-6673/1)
> > > alongside a fixed version of the printf format patch (6669/1) because
> > > without that, you get a bunch of compiler warnings.
> >
> > Except 6669/1 still suffers from "%#08llx".  For a value of one, that prints:
> >
> >         0x000001
> >
> > five zeros following the 0x rather than seven.  The width in the format
> > string includes the 0x prefix.
> 
> Ah, sorry, I only fixed one case and forgot about the rest (and
> misleading Will).
> 

I should've spotted this either way. I've superseded the old patch with
6674/1.

Apologies for the confusion,

Will



