Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1FFDrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:47:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:46597 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab1FFDra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:47:30 -0400
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linville@tuxdriver.com, LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, zajec5@gmail.com
In-Reply-To: <alpine.DEB.2.01.1106051907190.21697@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>
	 <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org>
	 <1306983467.29297.51.camel@pasglop>
	 <alpine.DEB.2.01.1106012057130.21697@trent.utfs.org>
	 <1307000008.29297.59.camel@pasglop>
	 <alpine.DEB.2.01.1106051907190.21697@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 13:46:51 +1000
Message-ID: <1307332011.2874.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 19:11 -0700, Christian Kujau wrote:
> On Thu, 2 Jun 2011 at 17:33, Benjamin Herrenschmidt wrote:
> > It -looks- to me that something goes wrong in the tty code when a large
> > file is piped through a pty, causing the kernel to hang for minutes in
> > the workqueue / ldisk flush code. I've just sent an initial report to
> > Alan Cox about it and am currently bisecting it.
> 
> This was the "tty vs workqueue oddities" thread, right? FWIW, 
> 55db4c64eddf37 ("Revert "tty: make receive_buf() return the amout of bytes 
> received"") seems to have fixed it on this powerpc machine as well.

Yup.

> With your "ssb: pci: Don't call PCIe specific workarounds on PCI cores" 
> patch applied, powerpc32 seems to be quite happy with 3.0-rc1+

Good :-)

Cheers,
Ben.


