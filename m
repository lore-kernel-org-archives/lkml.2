Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1HWUED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:04:03 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:50728 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756035Ab1HWUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:03:58 -0400
Date: Tue, 23 Aug 2011 13:03:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, an Abbott <abbotti@mev.co.uk>,
        ori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -next] staging: fix comedi build when COMEDI_PCI is not
 enabled
Message-Id: <20110823130356.dc54f74c.rdunlap@xenotime.net>
In-Reply-To: <20110823185805.GA11786@kroah.com>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
	<20110822111314.bf7a526f.rdunlap@xenotime.net>
	<20110823185805.GA11786@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 11:58:05 -0700 Greg KH wrote:

> On Mon, Aug 22, 2011 at 11:13:14AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix build when CONFIG_ISA_DMA_API is enabled but
> > CONFIG_COMEDI_PCI[_DRIVERS] is not enabled.
> > Fixes these build errors:
> > 
> > drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
> > drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
> > drivers/staging/comedi/drivers/ni_labpc.c: At top level:
> > drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
> > drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-
> 
> I applied your older patch, which causes this one to not apply.  Is it
> still needed as well?

Nope, the second (more recent) one is not needed.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
