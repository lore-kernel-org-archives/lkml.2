Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1BOLwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:52:33 -0500
Received: from service87.mimecast.com ([94.185.240.25]:40747 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754600Ab1BOLwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:52:31 -0500
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
 unsigned long for physical addresses
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110212102803.GC15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-16-git-send-email-catalin.marinas@arm.com>
	 <20110212102803.GC15616@n2100.arm.linux.org.uk>
Date: Tue, 15 Feb 2011 11:52:22 +0000
Message-ID: <1297770742.21448.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 15 Feb 2011 11:52:26.0704 (UTC) FILETIME=[D0D0E500:01CBCD06]
X-MC-Unique: 111021511522803501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, 2011-02-12 at 10:28 +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 24, 2011 at 05:55:57PM +0000, Catalin Marinas wrote:
> >  arch/arm/include/asm/memory.h     |   17 +++++++++--------
> >  arch/arm/include/asm/outercache.h |   14 ++++++++------
> >  arch/arm/include/asm/pgtable.h    |    2 +-
> >  arch/arm/include/asm/setup.h      |    2 +-
> >  arch/arm/kernel/setup.c           |    5 +++--
> >  arch/arm/mm/init.c                |    6 +++---
> >  arch/arm/mm/mmu.c                 |    7 ++++---
> >  7 files changed, 29 insertions(+), 24 deletions(-)
> 
> If this is split up into four separate patches, we can probably sort out
> merging this for the upcoming window.
> 
Excellent! I've split the patch up into four distinct parts, as per your
suggestions. I've submitted these to your patch system (6670/1-6673/1)
alongside a fixed version of the printf format patch (6669/1) because
without that, you get a bunch of compiler warnings.

Will


