Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0K0Agg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 19:36:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:45806 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab0K0Agf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 19:36:35 -0500
Date: Fri, 26 Nov 2010 16:37:16 -0800
From: Greg KH <gregkh@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Alan J. Wylie" <alan@wylie.me.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: Xen domU kernel no longer shuts down (Was Linux 2.6.32.26)
Message-ID: <20101127003716.GA12074@suse.de>
References: <20101122191547.GC4340@kroah.com> <19695.48938.271140.613069@wylie.me.uk> <4CF036CF.20606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF036CF.20606@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 02:38:07PM -0800, Jeremy Fitzhardinge wrote:
> On 11/26/2010 06:07 AM, Alan J. Wylie wrote:
> > Greg KH <gregkh@suse.de> writes:
> >
> >> I'm announcing the release of the 2.6.32.26 kernel.
> > ...
> >
> >> Alok Kataria (1):
> >>       x86, kexec: Make sure to stop all CPUs before exiting the kernel
> > This patch (ae832c21a08514fd11d2d1d6e217c8a537764bb0) stops my Xen DomU from
> > shutting down iff vcpus in the xen config file is > 1.
> >
> > Simply reverting the commit gets things working properly again.
> 
> Thanks for confirming this.  I had seen the same thing and suspected
> this change, but hadn't investigated it yet.
> 
> I'll try to get to a fix next week.

I'll revert this patch from the next .32 release to prevent the
regression.  Please resend this patch, and the fix, when you figure it
out.

thanks,

greg k-h
