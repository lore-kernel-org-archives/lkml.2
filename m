Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2IJQ3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:29:46 -0400
Received: from relais.videotron.ca ([24.201.245.36]:55312 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2IJQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:29:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 10 Sep 2012 12:29:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
In-reply-to: <20120910152102.GD31430@game.jcrosoft.org>
Message-id: <alpine.LFD.2.02.1209101227590.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-3-git-send-email-catalin.marinas@arm.com>
 <20120909172046.GB31430@game.jcrosoft.org>
 <alpine.LFD.2.02.1209091923180.28681@xanadu.home>
 <20120910055339.GC31430@game.jcrosoft.org> <20120910125137.GC27042@arm.com>
 <20120910152102.GD31430@game.jcrosoft.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 13:51 Mon 10 Sep     , Catalin Marinas wrote:
> > On Mon, Sep 10, 2012 at 06:53:39AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > On 19:29 Sun 09 Sep     , Nicolas Pitre wrote:
> > > > On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > > > On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
> > > > > > +The image must be placed at the specified offset (currently 0x80000)
> > > > > > +from the start of the system RAM and called there. The start of the
> > > > > > +system RAM must be aligned to 2MB.
> > > > > can we drop this
> > > > 
> > > > Drop what?
> > > > And why?
> > > This contrain the must be loadable at any address
> > 
> > You can't easily load the kernel image at any address, unless it can
> > relocate itself and you have a way to specify PHYS_OFFSET. We don't want
> > a compile-time PHYS_OFFSET, the kernel detects it at boot time based on
> > the load address.
> so NACK kexec and other boot loaders require it

I think you might have misunderstood something.

What's there now is perfectly sane.

SO I must NACK your NACK.  :-)


Nicolas
