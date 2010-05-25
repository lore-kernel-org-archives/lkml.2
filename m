Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0EYMhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:37:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55718 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab0EYMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:37:20 -0400
Date: Tue, 25 May 2010 13:37:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, luming.yu@intel.com, venki@google.com
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100525123701.GA7876@srcf.ucam.org>
References: <20100126084740.GA5265@jgarrett.org> <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org> <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain> <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 01:43:26AM -0400, Len Brown wrote:

> I'm told by the hardware guys that BM_STS is _not_ always
> a NOP, and so we're not supposed to simply ignore it on C3 --
> though it should be extremely rare that we see it set.
> If it is ever set, it should go on and off depending on 
> activity on some latency sensitive device, like out on the LPC.
> It may be possible for the BIOS writer to configure the chipset
> so that BM_STS is enabled always, presumably to accomodate
> some latency sensitve device -- or maybe by mistake.

On some hardware we've seen BM_STS be enabled approximately 50% of the 
time without any obvious cause.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
