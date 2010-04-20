Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0DTM1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:27:16 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59848 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab0DTM1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:27:14 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 08:27:14 EDT
Message-ID: <4BCD9B94.9090302@mev.co.uk>
Date: Tue, 20 Apr 2010 13:18:28 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100406 Thunderbird/3.0.3
MIME-Version: 1.0
To: Gustavo Silva <silvagustavosilva@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: comedi: drivers: fix coding style issues in
 das08.c
References: <>  <1271658070-10511-1-git-send-email-silvagustavo@users.sourceforge.net>
In-Reply-To: <1271658070-10511-1-git-send-email-silvagustavo@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/10 07:21, Gustavo Silva wrote:
> This is a patch to the das08.c file that fixes up the following issues
> found by the checkpatch.pl tool.

> -*/
>  /*
> -Driver: das08
> -Description: DAS-08 compatible boards
> -Author: Warren Jasper, ds, Frank Hess
> -Devices: [Keithley Metrabyte] DAS08 (isa-das08), [ComputerBoards] DAS08 (isa-das08),
> -  DAS08-PGM (das08-pgm),
> -  DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
> -  DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
> -  DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
> -  PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
> -Status: works
> -
> -This is a rewrite of the das08 and das08jr drivers.
> -
> -Options (for ISA cards):
> -        [0] - base io address
> -
> -Options (for pci-das08):
> -        [0] - bus  (optional)
> -        [1] = slot (optional)
> -
> -The das08 driver doesn't support asynchronous commands, since
> -the cheap das08 hardware doesn't really support them.  The
> -comedi_rt_timer driver can be used to emulate commands for this
> -driver.
> -*/
> + * Driver: das08
> + * Description: DAS-08 compatible boards
> + * Author: Warren Jasper, ds, Frank Hess
> + * Devices: [Keithley Metrabyte] DAS08 (isa-das08),
> + * [ComputerBoards] DAS08 (isa-das08), DAS08-PGM (das08-pgm),
> + * DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
> + * DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
> + * DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
> + * PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
> + * Status: works
> + *
> + * This is a rewrite of the das08 and das08jr drivers.
> + *
> + * Options (for ISA cards):
> + *             [0] - base io address
> + *
> + * Options (for pci-das08):
> + *             [0] - bus  (optional)
> + *             [1] = slot (optional)
> + *
> + * The das08 driver doesn't support asynchronous commands, since
> + * the cheap das08 hardware doesn't really support them.  The
> + * comedi_rt_timer driver can be used to emulate commands for this
> + * driver.
> + */

This part of the patch would screw up some scripts we have (in the CVS
version of comedi) for extracting driver documentation from the source code.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
