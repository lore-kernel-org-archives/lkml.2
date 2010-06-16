Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0FPHxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:53:24 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37583 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753101Ab0FPHxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:53:22 -0400
Date: Wed, 16 Jun 2010 09:53:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, linux-pm@lists.linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] idle-test patches queued for upstream
Message-ID: <20100616075259.GA1671@ucw.cz>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <201005271045.33500.trenn@suse.de>
 <alpine.LFD.2.00.1005272023510.24823@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005272023510.24823@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-05-27 20:59:07, Len Brown wrote:
> > > ... we think we can do better than ACPI.
> 
> > Why exactly? Is there any info missing in the ACPI tables?
> > Or is this just to be more independent from OEMs?
> 
> ACPI has a few fundmental flaws here.  One is that it reports
> exit latency instead of break-even power duration.
> The other is that it requires a BIOS writer to
> get the tables right.
> 
> Both of these are fatal flaws.

Intel is co-author of ACPI spec, right? So what about fixing those?
 
> > > Indeed, on my (production level commerically available) Nehalem desktop
> > > the ACPI tables are broken and an ACPI OS idles at 100W.  With this
> > > driver the box idles at 85W.
> 
> > What exactly was broken there?
> 
> Dell's BIOS developer botched a bug fix immediately before the system
> went to market and disabled support for all ACPI C-states except C1.
> After several month of shipping systems, they still were unable
> to ship them with a fixed BIOS.

I always thought that cpu vendors have ways to work with bios manufacturers...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
