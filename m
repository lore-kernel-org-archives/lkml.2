Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2CLRXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:23:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65469 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2CLRXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:23:08 -0400
Date: Mon, 12 Mar 2012 10:22:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Brown, Len" <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] cpuidle: Move cpuidle sysfs entry of each cpu to
 debugfs.
Message-ID: <20120312172258.GA29938@kroah.com>
References: <4F5466C4.2090808@intel.com>
 <20120305101827.GA19408@khazad-dum.debian.net>
 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
 <1330998885.1916.89.camel@ymzhang>
 <20120306052236.GA19416@kroah.com>
 <1331013078.1916.103.camel@ymzhang>
 <20120306143935.GA23346@kroah.com>
 <1331082051.1916.124.camel@ymzhang>
 <20120308180106.GD26516@kroah.com>
 <4F5DBFA8.3080300@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DBFA8.3080300@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:19:36PM +0800, ShuoX Liu wrote:
> I created a series to do this.
> 
> [PATCH 1/3] cpuidle: Move cpuidle sysfs entry of each cpu to debugfs.
> [PATCH 2/3] cpuidle: Add a debugfs entry to disable specific C state
> for debug purpose.
> [PATCH 3/3] cpupower: Update the cpupower tool for new debugfs
> entries of cpuidle.
> 
> Below are patches.

The patch is line-wrapped and can not be applied :(

> --- /dev/null
> +++ b/drivers/cpuidle/debugfs.c
> @@ -0,0 +1,176 @@
> +/*
> + * debugfs.c - debugfs support
> + *
> + * (C) 2006-2007 Shaohua Li <shaohua.li@intel.com>
> + * (C) 2012 ShuoX Liu <shuox.liu@intel.com>
> + *
> + * This code is licenced under the GPL.

What version of the GPL?

thanks,

greg k-h
