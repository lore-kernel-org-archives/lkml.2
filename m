Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab2CLUqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:46:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49135 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab2CLUqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:46:37 -0400
Date: Mon, 12 Mar 2012 20:46:30 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Valentin, Eduardo" <eduardo.valentin@ti.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Brown, Len" <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] cpuidle: Add a debugfs entry to disable specific C
 state for debug purpose.
Message-ID: <20120312204629.GA22929@srcf.ucam.org>
References: <20120305101827.GA19408@khazad-dum.debian.net>
 <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
 <1330998885.1916.89.camel@ymzhang>
 <20120306052236.GA19416@kroah.com>
 <1331013078.1916.103.camel@ymzhang>
 <20120306143935.GA23346@kroah.com>
 <1331082051.1916.124.camel@ymzhang>
 <20120308180106.GD26516@kroah.com>
 <4F5DBFA8.3080300@intel.com>
 <4F5DC01D.7040006@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5DC01D.7040006@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:21:33PM +0800, ShuoX Liu wrote:

> In addition, C state might have much impact on performance tuning,
> as it takes
> much time to enter/exit C states, which might delay interrupt
> processing. With
> the new debug option, developers could check if a deep C state could impact
> performance and how much impact it could cause.

Would anyone doing performance tuning not be using the cpu_dma_latency 
interface?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
