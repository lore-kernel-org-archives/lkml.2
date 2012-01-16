Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2APV0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:26:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34911 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2APV0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:26:51 -0500
Date: Mon, 16 Jan 2012 21:26:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 3.3
Message-ID: <20120116212640.GA6313@srcf.ucam.org>
References: <20120109003255.GA6598@havoc.gtf.org>
 <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org>
 <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr>
 <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
 <20120116194211.2cd09fb3@pyramind.ukuu.org.uk>
 <CA+55aFxNcAtCmzEejS=3+_L_rp-MOBS0yLS061YgiCsFw_Mt5Q@mail.gmail.com>
 <20120116195427.64edd96f@pyramind.ukuu.org.uk>
 <CA+55aFzXFyHTUv=8NtSmXA2UY_qO5P=HXdGnhUmF9YoA5vpX1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXFyHTUv=8NtSmXA2UY_qO5P=HXdGnhUmF9YoA5vpX1g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 12:02:32PM -0800, Linus Torvalds wrote:
> On Mon, Jan 16, 2012 at 11:54 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > Just ping Matthew about
> >
> > http://www.codon.org.uk/~mjg59/tmp/ahci_quirk_cleanup.diff
> 
> Hmm. This with just a setup option to enable it might well be good
> enough. No need for whitelists/blacklists, since we couldn't maintain
> those sanely anyway.
> 
> Matthew?

Last time I tested it it wasn't dealing well with setting up combination 
mode for devices with optical media, and I don't have much hardware 
lying around which still uses piix. But if I can find some time I'll dig 
something up and see if it still works. Or, if anyone else wants to do 
the same...

> Googling shows that there's a few old bugreports for this too (big
> surprise: macs):

Macs will come up with ahci if you boot via EFI rather than the BIOS 
compatibility module.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
