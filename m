Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab0EYSz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:55:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49286 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab0EYSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:55:25 -0400
Date: Tue, 25 May 2010 19:55:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: "Yu, Luming" <luming.yu@intel.com>, Philip Langdale <philipl@overt.org>,
       Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "venki@google.com" <venki@google.com>
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100525185507.GA15997@srcf.ucam.org>
References: <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain> <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain> <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com> <20100525124325.GC7876@srcf.ucam.org> <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:33:39AM -0400, Len Brown wrote:

> So if we see a nehalem system that has BM_STS *always* set,
> even when no devices are active in the system, my guess is
> that the BIOS mis-configured the chip-set and we should
> ignore that bit.  If BM_STS is changing at run time, then
> that is a more interesting situation, and we should endeavor
> to find what device activity is changing it.

Right. Determining that seems... awkward. FWIW, we've been shipping 
Luming's patch for several months now without anything obviously 
breaking in the process. This behaviour seems reasonably prevelant on 
Nehalem-EX systems.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
