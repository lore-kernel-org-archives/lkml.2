Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2FPRj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 13:39:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab2FPRj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 13:39:57 -0400
Date: Sat, 16 Jun 2012 19:39:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bojan Smojver <bojan@rexursive.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120616173952.GA20623@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Bojan Smojver <bojan@rexursive.com>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
 <20120524145122.GA26743@x1.osrc.amd.com>
 <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com>
 <201206161559.30267.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201206161559.30267.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 03:59:30PM +0200, Rafael J. Wysocki wrote:
> On Friday, May 25, 2012, Bojan Smojver wrote:
> > Borislav Petkov <bp@alien8.de> wrote:
> > 
> > >Let me ask again, can you send the last version of that patch so that I
> > >can give it a run pls?
> > 
> > 
> > Sorry. That patch is here (pretty much the original with signed-off):
> > 
> > http://marc.info/?l=linux-kernel&m=133651588229850&w=2
> 
> Queued up for 3.6 in linux-pm/linux-next.

IMHO, this one still needs a fix for the progress indicator output
landing in dmesg and filling it up with \x08 chars:

http://marc.info/?l=linux-pm&m=133848160403298&w=2

-- 
Regards/Gruss,
    Boris.
