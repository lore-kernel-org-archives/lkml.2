Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0IHC3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:29:36 -0400
Received: from mail.atheros.com ([12.19.149.2]:25266 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0IHC3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:29:34 -0400
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Greg KH <gregkh@suse.de>
CC: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Tue, 7 Sep 2010 19:29:30 -0700
Subject: RE: [PATCH 2/2] staging: ath6kl: use native methods from kernel
	library
Thread-Topic: [PATCH 2/2] staging: ath6kl: use native methods from kernel
	library
Thread-Index: ActO7GBE3Eo4y+v2Tw612FuATzaBOAADm08A
Message-ID: <35B17FE5076C7040809188FBE7913F983F2381D71F@SC1EXMB-MBCL.global.atheros.com>
References: <09b7da2e5462e0b855617ff5308ed6efb4fc9cab.1283872748.git.andy.shevchenko@gmail.com>
 <8b251244717765e795b92a1f7335f8af98e5706f.1283872748.git.andy.shevchenko@gmail.com>
 <35B17FE5076C7040809188FBE7913F983F23479F74@SC1EXMB-MBCL.global.atheros.com>
 <20100908000331.GA15785@suse.de>
In-Reply-To: <20100908000331.GA15785@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, September 07, 2010 5:04 PM
> To: Vipin Mehta
> Cc: Andy Shevchenko; linux-kernel@vger.kernel.org;
> devel@driverdev.osuosl.org
> Subject: Re: [PATCH 2/2] staging: ath6kl: use native methods from kernel
> library
> 
> On Tue, Sep 07, 2010 at 02:18:02PM -0700, Vipin Mehta wrote:
> > Andy,
> > Thanks for the patch. Although the driver supports Linux but it has
> > been architected to support other OSes if desired. The code is,
> > therefore, organized into generic and OS specific components with the
> > latter part of the code captured into the os/linux directory. As such,
> > the patch will be more useful if we can move out the inclusion of
> > linux specific header files <linux/kernel.h> and <linux/ctype.h> into
> > a header file in os/linux/include directory.
> 
> Ick, no.
> 
> The driver is now in the main kernel tree, the "compatiblity" wrappers
> are to now be removed as the kernel code does not need to run on any
> other operating systems.
> 
> That whole subdir needs to be deleted entirely.
> 
> > You can refer to
> > os/linux/include/osapi_linux.h for example. A macro could be defined
> > which would use linux specific APIs for Linux and keep the original
> > definitions for any other OS.
> 
> Again, no, this is not ok at all.  If you are going to insist on trying
> to do this for the driver, I will just delete it from the tree right now
> as that is now how kernel development happens, sorry.

Got it. I think we can discard my suggestion in that case. The patch looks good otherwise. It is ok from my side and could be pushed in to the driver.
 
> 
> thanks,
> 
> greg k-h
