Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab0EKR7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:59:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41234 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab0EKR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:59:12 -0400
Date: Tue, 11 May 2010 18:59:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull request] ACPI patches for 2.6.34-rc6
Message-ID: <20100511175904.GA18797@srcf.ucam.org>
References: <alpine.LFD.2.00.1005062216430.10792@localhost.localdomain> <alpine.LFD.2.00.1005061926460.901@i5.linux-foundation.org> <20100507061203.GA8779@srcf.ucam.org> <alpine.LFD.2.00.1005071402080.901@i5.linux-foundation.org> <20100507211331.GA28906@srcf.ucam.org> <alpine.LFD.2.00.1005071418200.901@i5.linux-foundation.org> <20100507213600.GC28906@srcf.ucam.org> <20100511172543.GA17868@srcf.ucam.org> <alpine.LFD.2.00.1005111031260.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005111031260.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 10:42:52AM -0700, Linus Torvalds wrote:

> Maybe windows does something else? Or do you _see_ windows doing that 
> write?

I see Windows write the SCI_EN bit without reading it first and without 
calling the ACPI enable SMM function.

> will write it _even_if_ the bit was already set. That could explain 
> Rafael's problems too - writing the register directly may be the 
> RightThing(tm), but writing it if the bit was already set may well cause 
> some confusion.

Like I said, I don't see any reads on resume - only on system boot.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
