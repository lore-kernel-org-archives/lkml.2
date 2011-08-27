Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984Ab1H0Ek7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 00:40:59 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50511
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab1H0Ek6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 00:40:58 -0400
Date: Sat, 27 Aug 2011 00:40:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
Message-ID: <20110827044050.GA3549@infradead.org>
References: <4E582577.2060805@zytor.com>
 <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com>
 <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <4E5840FE.5090705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5840FE.5090705@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 05:57:34PM -0700, H. Peter Anvin wrote:
> On 08/26/2011 05:36 PM, Linus Torvalds wrote:
> > If you want to be compatible with "int 0x80" and old libraries, then I
> > really don't see why you would introduce *anything* new.
> 
> Just to be clear, the reason to keep the LFS stuff in there was to be
> compatible with the existing 32-bit *programming model*, so that a
> program recompiled from i386 to x32 should behave the same.
> 
> Not that anyone should compile without -D_FILE_OFFSET_BITS=64 these days...

Any new port should not even offer non-LFS system calls.  They are a
pain in the but, and I would sacrifice chicken if we coud stop glibc
offering it as a default that way.

> 
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
