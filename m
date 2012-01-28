Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2A2A16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 19:27:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2A2A15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 19:27:57 -0500
Date: Sat, 28 Jan 2012 10:05:25 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFCv2 01/14] irq_domain: add documentation and MAINTAINERS
 entry.
Message-ID: <20120128170525.GA2501@ponder.secretlab.ca>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
 <1327352870-14687-2-git-send-email-grant.likely@secretlab.ca>
 <4F1F02E5.3000605@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1F02E5.3000605@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:13:41AM -0800, Randy Dunlap wrote:
> On 01/23/2012 01:07 PM, Grant Likely wrote:
> > Documentation for irq_domain library which will be created in subsequent
> > patches.
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  Documentation/IRQ-domain.txt |  113 ++++++++++++++++++++++++++++++++++++++++++
> >  MAINTAINERS                  |    9 +++
> >  2 files changed, 122 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/IRQ-domain.txt
> > 
> > diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
> > new file mode 100644
> > index 0000000..247f32a
> > --- /dev/null
> > +++ b/Documentation/IRQ-domain.txt
> > @@ -0,0 +1,113 @@
> > +irq_domain interrupt number mapping library
> > +
> > +The current design of the Linux kernel uses a single large number
> > +space where each separate IRQ source is assigned a different number.
> > +This is simple when there is only one interrupt controller, but in
> > +systems with controllers the kernel must ensure that each one does not
> 
>            with multiple interrupt controllers,

Hi Randy.  Thanks for the comments.  I've made the changes and they'll appear
in v4 of the series.

g.

