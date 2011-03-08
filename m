Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1CHFbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:31:49 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48154 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1CHFbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:31:47 -0500
Date: Tue, 8 Mar 2011 05:32:26 +0000
From: Andres Salomon <dilinger@queued.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110308053226.7300e65d@debxo>
In-Reply-To: <20110307144700.GF1829@sirena.org.uk>
References: <20110304080653.3f2c3f19@debxo>
	<4D710FF9.6040305@ru.mvista.com>
	<20110304083822.0f40d120@debxo>
	<4D713670.70506@ru.mvista.com>
	<20110307144700.GF1829@sirena.org.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011 14:47:00 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Fri, Mar 04, 2011 at 09:58:56PM +0300, Sergei Shtylyov wrote:
> > Andres Salomon wrote:
> 
> >>>> MFD changes in c738892f cause the mc13xxx_platform_data struct
> 
> >>>     Linus asks to also specify the commit summary in parens.
> 
> >> Also, what?  If there are changes to how patches should be
> >> submitted, please provide a reference
> >> (Documentation/SubmittingPatches should be updated, as well).
> 
> >    I have no time to rummage in the mail archives, sorry.
> 
> There's been multiple discussions of this.  The issue is that commit
> IDs only mean something in specific trees and go bad if someone
> rebases, and they aren't legibile by humans (so even if the commit is
> in something like Linus' tree the reader still needs a git repository
> to figure out what changes are being talked about).

Ah, thanks, that makes sense.  Sergei's original statement was unclear
("...instead of just the commit ID" would've helped).


