Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758Ab1CDQi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:38:29 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48674 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580Ab1CDQi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:38:27 -0500
Date: Fri, 4 Mar 2011 08:38:22 -0800
From: Andres Salomon <dilinger@queued.net>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110304083822.0f40d120@debxo>
In-Reply-To: <4D710FF9.6040305@ru.mvista.com>
References: <20110304080653.3f2c3f19@debxo>
	<4D710FF9.6040305@ru.mvista.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Mar 2011 19:14:49 +0300
Sergei Shtylyov <sshtylyov@mvista.com> wrote:

> Hello.
> 
> Andres Salomon wrote:
> 
> > Note that this relies on stuff currently in mfd's next tree, but
> > this is also a newer driver.  I'm not sure which tree it should go
> > through, as it's a problem that shows up in next.
> 
>     This passage should be under --- tear line.

What?


> 
> > From: Andres Salomon <dilinger@queued.net>
> 
> > MFD changes in c738892f cause the mc13xxx_platform_data struct
> 
>     Linus asks to also specify the commit summary in parens.
> 

Also, what?  If there are changes to how patches should be submitted,
please provide a reference (Documentation/SubmittingPatches should
be updated, as well).



> > to change.  This changes one more (new) user of it, fixing a build
> > error.
> 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> WBR, Sergei

