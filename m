Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab0ENQgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:36:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47853 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0ENQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:36:07 -0400
Date: Fri, 14 May 2010 17:35:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100514163557.GA7843@srcf.ucam.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100514145539.GA5598@srcf.ucam.org> <20100514162951.GB31607@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514162951.GB31607@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 09:29:52AM -0700, Dmitry Torokhov wrote:
> On Fri, May 14, 2010 at 03:55:39PM +0100, Matthew Garrett wrote:
> > I've done some experimentation under qemu. On ACPI systems, Windows will 
> > *only* touch the keyboard controller if there's a device with an 
> > appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
> > Otherwise it'll simply ignore the hardware entirely. By the looks of it 
> > their keyboard probing is also somewhat different to ours, but that's 
> > probably another story.
> > 
> > However, I did find a couple of device IDs that machines may produce 
> > which we don't currently check for. I'll send a patch.
> > 
> 
> I was wondering if we should be matching for _CID instead of _HID for
> mouse and keyboard.

I'm pretty sure the PNP layer will bind to either _HID or _CID.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
