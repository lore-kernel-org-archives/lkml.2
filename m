Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2CLT3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:29:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48315 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab2CLT3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:29:43 -0400
Date: Mon, 12 Mar 2012 12:29:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
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
Message-ID: <20120312192936.GC24873@kroah.com>
References: <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
 <4F545A4E.8010801@linux.vnet.ibm.com>
 <4F5466C4.2090808@intel.com>
 <20120305101827.GA19408@khazad-dum.debian.net>
 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
 <1330998885.1916.89.camel@ymzhang>
 <20120306052236.GA19416@kroah.com>
 <1331013078.1916.103.camel@ymzhang>
 <20120306143935.GA23346@kroah.com>
 <20120312181151.GE14020@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312181151.GE14020@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 06:11:51PM +0000, Mark Brown wrote:
> On Tue, Mar 06, 2012 at 06:39:35AM -0800, Greg KH wrote:
> 
> > Do you know of any tools using these files?  I have never heard of them,
> > and I was told we should move these files years ago.  So I don't think
> > there should be any api issues.
> 
> powertop uses them.

Ok, then we can't move them all.

We should then just move the ones that have multiple lines, as I'm
pretty sure powertop doesn't use them, right?

thanks,

greg k-h
