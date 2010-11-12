Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0KLMRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:17:45 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:52967
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0KLMRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:17:44 -0500
Date: Fri, 12 Nov 2010 21:17:42 +0900
From: Mattia Dongili <malattia@linux.it>
To: Norbert Preining <preining@logic.at>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112121742.GA17690@kamineko.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at>
 <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101112043922.GA19889@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112043922.GA19889@gamma.logic.tuwien.ac.at>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.35+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 01:39:22PM +0900, Norbert Preining wrote:
> On Fr, 12 Nov 2010, Mattia Dongili wrote:
> > backlight (actually Fn+F[56]) is one of those keys the needs remapping
> > these days, i.e. if xev doesn't get any event in X then you may need
> 
> It doesn't.

You will need an updated input-kbd to set the scancode map.

> > $ diff -u <(sudo input-kbd 5) vaio-kbd
> > /dev/input/event5
> >    bustype : BUS_ISA
> >    vendor  : 0x104d
> >    product : 0x0
> >    version : 0
> >    name    : "Sony Vaio Keys"
> >    bits ev : EV_SYN EV_KEY EV_MSC
> 
> Ahhhhh
> 	root$ input-kbd 8
> 	/dev/input/event8
> 	protocol version mismatch (expected 65536, got 65537)
> and the same for all event devices??
> 
> I have input-kbd from xserver-xorg-input-kbd in Debian/sid, which is
> at 1:1.4.0-2 version.
> 
> Does that mean that 2.6.37rc is too new for the user space?

Maybe. Anyway if evtest reacts positively to key presses then it's a
userspace issue and not the driver's.

-- 
mattia
:wq!
