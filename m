Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0DTNmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 09:42:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0DTNmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 09:42:46 -0400
Date: Tue, 20 Apr 2010 06:42:33 -0700
From: Greg KH <gregkh@suse.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Gustavo Silva <silvagustavosilva@gmail.com>,
       "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: comedi: drivers: fix coding style issues in
 das08.c
Message-ID: <20100420134233.GA27884@suse.de>
References: <>
 <1271658070-10511-1-git-send-email-silvagustavo@users.sourceforge.net>
 <4BCD9B94.9090302@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCD9B94.9090302@mev.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:18:28PM +0100, Ian Abbott wrote:
> On 19/04/10 07:21, Gustavo Silva wrote:
> > This is a patch to the das08.c file that fixes up the following issues
> > found by the checkpatch.pl tool.
> 
> > -*/
> >  /*
> > -Driver: das08
> > -Description: DAS-08 compatible boards
> > -Author: Warren Jasper, ds, Frank Hess
> > -Devices: [Keithley Metrabyte] DAS08 (isa-das08), [ComputerBoards] DAS08 (isa-das08),
> > -  DAS08-PGM (das08-pgm),
> > -  DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
> > -  DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
> > -  DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
> > -  PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
> > -Status: works
> > -
> > -This is a rewrite of the das08 and das08jr drivers.
> > -
> > -Options (for ISA cards):
> > -        [0] - base io address
> > -
> > -Options (for pci-das08):
> > -        [0] - bus  (optional)
> > -        [1] = slot (optional)
> > -
> > -The das08 driver doesn't support asynchronous commands, since
> > -the cheap das08 hardware doesn't really support them.  The
> > -comedi_rt_timer driver can be used to emulate commands for this
> > -driver.
> > -*/
> > + * Driver: das08
> > + * Description: DAS-08 compatible boards
> > + * Author: Warren Jasper, ds, Frank Hess
> > + * Devices: [Keithley Metrabyte] DAS08 (isa-das08),
> > + * [ComputerBoards] DAS08 (isa-das08), DAS08-PGM (das08-pgm),
> > + * DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
> > + * DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
> > + * DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
> > + * PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
> > + * Status: works
> > + *
> > + * This is a rewrite of the das08 and das08jr drivers.
> > + *
> > + * Options (for ISA cards):
> > + *             [0] - base io address
> > + *
> > + * Options (for pci-das08):
> > + *             [0] - bus  (optional)
> > + *             [1] = slot (optional)
> > + *
> > + * The das08 driver doesn't support asynchronous commands, since
> > + * the cheap das08 hardware doesn't really support them.  The
> > + * comedi_rt_timer driver can be used to emulate commands for this
> > + * driver.
> > + */
> 
> This part of the patch would screw up some scripts we have (in the CVS
> version of comedi) for extracting driver documentation from the source code.

What type of scripts are they and what is the requirements for them so
that we know not to mess them up?

And how about just using kerneldoc?

thanks,

greg k-h
