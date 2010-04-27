Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0D0HH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:07:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:37496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab0D0HH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:07:28 -0400
Date: Tue, 27 Apr 2010 09:07:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [049/197] x86, amd: Get multi-node CPU info from NodeId MSR
 instead of PCI config space
In-Reply-To: <20100427065534.GB6248@alberich.amd.com>
Message-ID: <alpine.LNX.2.00.1004270906370.7579@pobox.suse.cz>
References: <20100422190911.735233389@kvm.kroah.org> <alpine.LNX.2.00.1004261906410.7579@pobox.suse.cz> <20100427065534.GB6248@alberich.amd.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Andreas Herrmann wrote:

> > > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > This patch is causing kernel panic on boot on Magny Cours CPU here 
> > (cpu family 16, model 9, stepping 1).
> > 
> > Please see screenshot from the paniced kernel on 
> > 
> >    http://www.jikos.cz/jikos/junk/screenshot.jpg 
> > 
> > (sorry for bad quality of this screenshot, it was captured only from the 
> > IPMI/HTTP console so far, I will try to grab something better tomorrow)
> > 
> > Also this screenshot probably doesn't show the complete picture -- see the 
> > "end trace" marker on the very first line. I will try to have something 
> > better tomorrow, but maybe this rings bell for someone right away.
> 
> This looks like a BIOS issue to me. Obviously this is a pre-production
> test system where an old BIOS is installed. A BIOS update should fix
> this issue for you.

I can confirm that on different Magny Cours system (16/9/1) with a newer 
BIOS, the NodeID is provided correctly via MSR, and the issue doesn't 
trigger.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
