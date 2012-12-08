Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2LHHgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 02:36:37 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53233 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab2LHHgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 02:36:35 -0500
Date: Sat, 8 Dec 2012 08:36:34 +0100
From: Andreas Mohr <andi@lisas.de>
To: Borislav Petkov <bp@alien8.de>, Andreas Mohr <andi@lisas.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121208073634.GA30690@rhlx01.hs-esslingen.de>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
 <20121205153121.GA28556@liondog.tnic>
 <20121205133853.770451ca.akpm@linux-foundation.org>
 <20121207165218.GA13421@rhlx01.hs-esslingen.de>
 <20121207174405.GF27523@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207174405.GF27523@liondog.tnic>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 07, 2012 at 06:44:05PM +0100, Borislav Petkov wrote:
> On Fri, Dec 07, 2012 at 05:52:18PM +0100, Andreas Mohr wrote:
> > Hmm, anyone deeply familiar with ISA PnP ID magic? :)
> 
> Even if this is violating the ACPI spec, any fix for this needs to be
> tested on the hardware (and I can very well imagine that the hardware
> might be violating the spec too, nothing new here).
> 
> So even if you had a fix, you need to run it on the hardware to verify
> that it actually works.

And that demand actually applies to both the '@' change (questionable)
and the much less disputed (obviously correct) wrong conditional fixup,
since both introduce a notable change (either large, or possibly
improper) in behaviour.

> So the actual practical question turns into: do you have such hardware
> to verify your or anyone else's fix on?

Not the ALS100 (only ALS4000 here).
I possibly have some other ISA hardware, but probably none which contains
'@' data in their PnP id struct.
The driver for the well-known case of ISDN PnP cards
does not seem to contain it.
However ISTR that CMI8330 was quite widespread (did I have one? Do I??).
For identification, see http://www.yjfy.com/C/C-Media/soundchipset/CMI8330A.htm

I'm afraid I should get an old system back up and running,
exactly for such validation work cases (and perhaps so should a select few
other developers, too).

BTW, "my" fix? I thought that everybody had come to the conclusion by now
that I merely pointed out (in no uncertain terms to boot)
that something was broken :)

Andreas Mohr
