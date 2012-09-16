Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2IPA2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 20:28:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51027 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2IPA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 20:28:22 -0400
Date: Sat, 15 Sep 2012 17:28:16 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 13/31] arm64: Device specific operations
Message-ID: <20120916002816.GA7028@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <20120815003355.GF19607@quad.lixom.net>
 <20120914172944.GB2927@arm.com>
 <201209141731.59938.arnd@arndb.de>
 <20120914173946.GE2927@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914173946.GE2927@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:39:46PM +0100, Catalin Marinas wrote:
> On Fri, Sep 14, 2012 at 06:31:59PM +0100, Arnd Bergmann wrote:
> > On Friday 14 September 2012, Catalin Marinas wrote:
> > > (revisiting unanswered emails :))
> > > 
> > > On Wed, Aug 15, 2012 at 01:33:55AM +0100, Olof Johansson wrote:
> > > > On Tue, Aug 14, 2012 at 06:52:14PM +0100, Catalin Marinas wrote:
> > > > > +/*
> > > > > + *  I/O port access primitives.
> > > > > + */
> > > > > +#define IO_SPACE_LIMIT             0xffff
> > > > > +
> > > > > +/*
> > > > > + * We currently don't have any platform with PCI support, so just leave this
> > > > > + * defined to 0 until needed.
> > > > > + */
> > > > > +#define PCI_IOBASE         ((void __iomem *)0)
> > > > 
> > > > You could just leave out the PCI / I/O code alltogether instead.
> > > 
> > > I would leave this in as some of the first platforms to appear will have
> > > PCIe. At some point we'll add a fixed address where the PCI_IOBASE is
> > > mapped.
> > > 
> > 
> > I guess the cleanest way would be to reserve a virtual memory region right away
> > and document it in the file where you describe the memory layout. Then you can
> > fill the value in here.
> 
> Yes, easy to do. Any access will fault until we add the PCI support.

Sounds good to me.


-Olof
