Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2CMT34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:29:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53902 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2CMT3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:29:55 -0400
Date: Tue, 13 Mar 2012 12:29:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Brown, Len" <len.brown@intel.com>, ShuoX Liu <shuox.liu@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, andi.kleen@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH V3] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
Message-ID: <20120313192949.GA8568@kroah.com>
References: <4F5466C4.2090808@intel.com>
 <20120305101827.GA19408@khazad-dum.debian.net>
 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
 <1330998885.1916.89.camel@ymzhang>
 <20120306052236.GA19416@kroah.com>
 <1331013078.1916.103.camel@ymzhang>
 <20120306143935.GA23346@kroah.com>
 <20120312181151.GE14020@sirena.org.uk>
 <20120312192936.GC24873@kroah.com>
 <1331602594.1916.155.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331602594.1916.155.camel@ymzhang>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 09:36:34AM +0800, Yanmin Zhang wrote:
> On Mon, 2012-03-12 at 12:29 -0700, Greg KH wrote:
> > On Mon, Mar 12, 2012 at 06:11:51PM +0000, Mark Brown wrote:
> > > On Tue, Mar 06, 2012 at 06:39:35AM -0800, Greg KH wrote:
> > > 
> > > > Do you know of any tools using these files?  I have never heard of them,
> > > > and I was told we should move these files years ago.  So I don't think
> > > > there should be any api issues.
> > > 
> > > powertop uses them.
> > 
> > Ok, then we can't move them all.
> > 
> > We should then just move the ones that have multiple lines, as I'm
> > pretty sure powertop doesn't use them, right?
> All sys files under cpu/cpuXXX/cpuidle have single line. If we move
> some files to debugfs and keep others under sysfs, users might be confused.
> 
> Should we go back to the 1st version which just adds the new entry to
> sysfs?

Wait, I thought this whole thing started when we wanted to move the
files that had multiple lines out of sysfs?

If none of these do, and they all are being used by tools already, then
fine, they should stay.

But for some reason, I thought there was a problem here.  Perhaps that
was in the cpufreq code?

confused,

greg k-h
