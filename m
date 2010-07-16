Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab0GPUb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:31:56 -0400
Received: from lo.gmane.org ([80.91.229.12]:53207 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192Ab0GPUby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:31:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] Remove 9 second reboot delay on Lenovo T400/T500
Date: Fri, 16 Jul 2010 22:31:40 +0200
Message-ID: <20100716223140.69696431@schatten.dmk.lab>
References: <4C3DCAA4.9050602@gmail.com>
	<4C400C8E.8060500@gmx.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: ibm-acpi-devel@lists.sourceforge.net
X-Gmane-NNTP-Posting-Host: f053213020.adsl.alicedsl.de
In-Reply-To: <4C400C8E.8060500@gmx.info>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 09:38:54 +0200
Jens Rutschmann <Jens.Rutschmann@gmx.info> wrote:

> Am 14.07.2010 16:33 schrieb Pedro Ribeiro:
> > Please consider this patch. Let me know if you would like me to change
> > anything or if you don't agree with it. It applies cleanly to 2.6.35-rc5.
> >
> > The Lenovo T400 and T500 have an annoying 9 second delay when
> > rebooting, unless reboot=pci is passed to the kernel command line.
> > This delay happens from at least kernel 2.6.20.
> >
> > Make this change permanent by hardcoding the Tx00 on the
> > arch/kernel/reboot.c pci quirks table.
> 
> Hi,
> 
> I just want to add to this discussion that this problem also occurs on my T61 with only Linux installed on it.
> "reboot=pci" also removed the reboot delay here.
> 
> If you need some further information or want me to try some patches / old kernels I'd be glad to help.
> 
> Regards,
> Jens
> 
Hi!

Just a quick me too: I'm on Lenovo R61. reboot=pci gives instantaneous
reboot, reboot=acpi and default-reboot delays for 9 seconds...

Cheers,
Flo

