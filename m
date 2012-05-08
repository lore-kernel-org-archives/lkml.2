Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2EHDUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:20:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab2EHDUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:20:24 -0400
Message-ID: <1336447221.7364.2.camel@marge.simpson.net>
Subject: Re: [PATCH] clockevents: Per cpu tick skew boot option
From: Mike Galbraith <mgalbraith@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 08 May 2012 05:20:21 +0200
In-Reply-To: <alpine.LFD.2.02.1205072115000.6271@ionos>
References: <1336309127.7351.13.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1205072115000.6271@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 21:17 +0200, Thomas Gleixner wrote: 
> On Sun, 6 May 2012, Mike Galbraith wrote:
> >  
> > +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> > +			xtime_lock contention on larger systems.  Note: increases
> > +			power consumption, and should only be enabled if running
> > +			jitter sensitive (HPC/RT) workloads.
> > +
> 
> The "=" is wrong as skew_tick should not take parameters. It's
> disabled by default. So "skew_tick" simply enables it, right ?

Unless as I have RT set up, it's turned on by default, so '=' lets the
user turn it back off.

-Mike

