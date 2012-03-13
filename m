Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab2CMBhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:37:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:62977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272Ab2CMBhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:37:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="137743977"
Subject: Re: [linux-pm] [PATCH V3] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Greg KH <gregkh@linuxfoundation.org>
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
In-Reply-To: <20120312192936.GC24873@kroah.com>
References: <C6CB66606345BC4B80CBE69D22ABFBB10220E1@SHSMSX101.ccr.corp.intel.com>
	 <4F545A4E.8010801@linux.vnet.ibm.com> <4F5466C4.2090808@intel.com>
	 <20120305101827.GA19408@khazad-dum.debian.net>
	 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
	 <1330998885.1916.89.camel@ymzhang> <20120306052236.GA19416@kroah.com>
	 <1331013078.1916.103.camel@ymzhang> <20120306143935.GA23346@kroah.com>
	 <20120312181151.GE14020@sirena.org.uk>  <20120312192936.GC24873@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: UMG
Date: Tue, 13 Mar 2012 09:36:34 +0800
Message-ID: <1331602594.1916.155.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 12:29 -0700, Greg KH wrote:
> On Mon, Mar 12, 2012 at 06:11:51PM +0000, Mark Brown wrote:
> > On Tue, Mar 06, 2012 at 06:39:35AM -0800, Greg KH wrote:
> > 
> > > Do you know of any tools using these files?  I have never heard of them,
> > > and I was told we should move these files years ago.  So I don't think
> > > there should be any api issues.
> > 
> > powertop uses them.
> 
> Ok, then we can't move them all.
> 
> We should then just move the ones that have multiple lines, as I'm
> pretty sure powertop doesn't use them, right?
All sys files under cpu/cpuXXX/cpuidle have single line. If we move
some files to debugfs and keep others under sysfs, users might be confused.

Should we go back to the 1st version which just adds the new entry to
sysfs?

In addition, should we move powertop to tools/?

Yanmin


