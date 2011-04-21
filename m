Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1DUKU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:20:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1DUKU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:20:26 -0400
Date: Thu, 21 Apr 2011 12:20:00 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Russ Anderson <rja@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Message-ID: <20110421102000.GD10263@aftab>
References: <1302857141-17580-1-git-send-email-bp@amd64.org>
 <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
 <20110421093554.GB4262@elte.hu>
 <20110421095114.GB10263@aftab>
 <20110421095848.GA14889@elte.hu>
 <20110421100639.GC10263@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421100639.GC10263@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 06:06:39AM -0400, Borislav Petkov wrote:
> On Thu, Apr 21, 2011 at 05:58:48AM -0400, Ingo Molnar wrote:
> > Ok, indeed. Also, in the future, if you take patches from others please also 
> > credit them in the changelog. Something like this would have been good in the 
> > current case:
> > 
> >   Also, this patch includes a change from Nagananda Chumbalkar as well, which 
> >   drops tainting in the therma throttling code for a similar reason: crossing a
> >   thermal threshold does not mean corruption.
> > 
> > Nagananda's Acked-by is there so there's at least partial credit - but we 
> > generally try to aim for at least 100% credit where credit is due :-)
> 
> Absolutely, and in the light of recent events :) I'm still not sure how
> to do that though in a straight-forward manner so that it is visible at
> a first glance. Sure, adding freeform text to the commit message is one
> way. Using a SOB chain might work too - even the Acked-by tag - but all
> those have another main purpose and are being repurposed for annotating
> the fact that a patch is the result of more than one author's thought
> process.
> 
> IOW, in case I'm not missing anything, we don't really have a way to
> denote a multiple authorship, correct? And we should...

Ok, after RTFMing <Documentation/SubmittingPatches> here's how:

From: Original Author <author@example.com>

	^ this is the original author who sent the initial patch

Signed-off-by: Original Author <author@example.com>
Signed-off-by: Additional Author <author2@example.com>
Signed-off-by: Third Author <author3@example.com>

and the SOBs following after the 1st one are denoting additional authors.

However, additional SOBs mean also subsystem maintainers on the delivery
path of the patch. I guess this is ok though.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
