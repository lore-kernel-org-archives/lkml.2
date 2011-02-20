Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1BTQuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:50:44 -0500
Received: from kroah.org ([198.145.64.141]:43839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1BTQun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:50:43 -0500
Date: Sun, 20 Feb 2011 08:50:02 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, stefanb@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-pm <linux-pm@lists.linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [REVERT request stable-2.6.36/37] Re: 2.6.37.1 s2disk
 regression (TPM)
Message-ID: <20110220165002.GA19771@kroah.com>
References: <4D60E93D.1050205@gmail.com>
 <201102201144.34043.rjw@sisk.pl>
 <4D60F108.9000106@gmail.com>
 <201102201151.11635.rjw@sisk.pl>
 <4D60F38C.5050704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D60F38C.5050704@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 11:57:16AM +0100, Jiri Slaby wrote:
> On 02/20/2011 11:51 AM, Rafael J. Wysocki wrote:
> > On Sunday, February 20, 2011, Jiri Slaby wrote:
> >> On 02/20/2011 11:44 AM, Rafael J. Wysocki wrote:
> >>> On Sunday, February 20, 2011, Jiri Slaby wrote:
> >>>> Hi,
> >>>>
> >>>> I'm unable to hibernate 2.6.37.1 unless I rmmod tpm_tis:
> >>>> [10974.074587] Suspending console(s) (use no_console_suspend to debug)
> >>>> [10974.103073] tpm_tis 00:0c: Operation Timed out
> >>>> [10974.103089] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
> >>>> [10974.103095] PM: Device 00:0c failed to freeze: error -62
> >>>>
> >>>> 2.6.37 worked fine. Going to revert 9b29050f8f7 (tpm_tis: Use timeouts
> >>>> returned from TPM) for testing.
> >>>
> >>> Yes, this has been confirmed to cause suspend regressions to happen
> >>
> >> OK, the revert works for me too... Are there any fixes?
> > 
> > No, and the author and maintainer have not been responding.  If that contiunes,
> > I'll simply ask Linus to revert it.
> 
> Ok then, stable team, please revert that from 2.6.37 stable.

Ok, I'll do that for the next .37-stable release.

> I guess the same problem is in 2.6.36, so reverting it in 2.6.36 should
> be done too...

.36-stable is now end-of-life :(

thanks,

greg k-h
