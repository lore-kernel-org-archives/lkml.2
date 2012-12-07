Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423520Ab2LGRoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:44:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40031 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423351Ab2LGRoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:44:09 -0500
Date: Fri, 7 Dec 2012 18:44:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121207174405.GF27523@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andreas Mohr <andi@lisas.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
 <20121205153121.GA28556@liondog.tnic>
 <20121205133853.770451ca.akpm@linux-foundation.org>
 <20121207165218.GA13421@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121207165218.GA13421@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 05:52:18PM +0100, Andreas Mohr wrote:
> I hate having to rain on the parade again ;) I just developed
> some doubts, by accident again, by getting dangerously near
> sound/isa/als100.c snd_als100_pnpids: there are many IDs with '@'
> embedded (at least in this ISA-based PnP code), thus I guess that
> code may have had its justification (unless ACPI 5.0 is clearly fully
> authoritative for this space and thus '@' does not have any business
> there any more).
>
> Dito e.g. isa/cmi8330.c.
>
> Hmm, anyone deeply familiar with ISA PnP ID magic? :)

Even if this is violating the ACPI spec, any fix for this needs to be
tested on the hardware (and I can very well imagine that the hardware
might be violating the spec too, nothing new here).

So even if you had a fix, you need to run it on the hardware to verify
that it actually works.

So the actual practical question turns into: do you have such hardware
to verify your or anyone else's fix on?

Thanks.

-- 
Regards/Gruss,
    Boris.
