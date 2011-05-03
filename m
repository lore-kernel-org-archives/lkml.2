Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1ECJhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:37:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1ECJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:37:22 -0400
Date: Tue, 3 May 2011 10:36:59 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ulrich Weigand <ulrich.weigand@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, patches@linaro.org
Subject: Re: [PATCH v4 1/2] ARM: ELF: Define new core note type for VFP
 registers
Message-ID: <20110503093659.GA2503@arm.com>
References: <1302688597-2969-1-git-send-email-dave.martin@linaro.org>
 <1302688597-2969-2-git-send-email-dave.martin@linaro.org>
 <20110428184925.GM17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428184925.GM17290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 07:49:25PM +0100, Russell King - ARM Linux wrote:
> On Wed, Apr 13, 2011 at 10:56:36AM +0100, Dave Martin wrote:
> > The VFP registers are not currently included in coredumps,
> > and there's no existing note type where they can sensibly be
> > included, so this patch defines a dedicated note type for them.
> 
> This probably wants to be copied to LKML (added).

Good point-- thanks.

---Dave

> 
> > Signed-off-by: Dave Martin <dave.martin@linaro.org>
> > Acked-by: Will Deacon <Will.Deacon@arm.com>
> > ---
> >  include/linux/elf.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/elf.h b/include/linux/elf.h
> > index 4d60801..110821c 100644
> > --- a/include/linux/elf.h
> > +++ b/include/linux/elf.h
> > @@ -395,6 +395,7 @@ typedef struct elf64_shdr {
> >  #define NT_S390_CTRS	0x304		/* s390 control registers */
> >  #define NT_S390_PREFIX	0x305		/* s390 prefix register */
> >  #define NT_S390_LAST_BREAK	0x306	/* s390 breaking event address */
> > +#define NT_ARM_VFP	0x400		/* ARM VFP/NEON registers */
> >  
> >  
> >  /* Note header in a PT_NOTE section */
> > -- 
> > 1.7.1
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
