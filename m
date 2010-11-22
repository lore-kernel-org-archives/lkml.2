Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0KVNtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:49:40 -0500
Received: from service87.mimecast.com ([94.185.240.25]:52895 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753511Ab0KVNth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:49:37 -0500
Subject: Re: [PATCH v2 19/20] ARM: LPAE: define printk format for physical
 addresses and page table entries
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
In-Reply-To: <20101122134325.GK31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	 <1289584840-18097-20-git-send-email-catalin.marinas@arm.com>
	 <20101122134325.GK31227@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 22 Nov 2010 13:49:31 +0000
Message-ID: <1290433771.29754.34.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 22 Nov 2010 13:49:31.0565 (UTC) FILETIME=[16D8DDD0:01CB8A4C]
X-MC-Unique: 110112213493300601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 13:43 +0000, Russell King - ARM Linux wrote:
> On Fri, Nov 12, 2010 at 06:00:39PM +0000, Catalin Marinas wrote:
> > From: Will Deacon <will.deacon@arm.com>
> >
> > Now that the Kernel supports 2 level and 3 level page tables, physical
> > addresses (and also page table entries) may be 32 or 64-bits depending
> > upon the configuration.
> >
> > This patch adds a conversion specifier (PHYS_ADDR_FMT) which represents
> > a u32 or u64 depending on the width of a physical address.
> 
> I hope this patch is gone in v3.

Yes, everything is converted to %08llx now.

Once you complete your clean-up, I'll rebase the LPAE patches on top and
repost a new v4 version.

-- 
Catalin


