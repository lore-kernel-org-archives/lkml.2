Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0H3N4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:56:51 -0400
Received: from plane.gmane.org ([80.91.229.3]:40784 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab0H3N4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:56:50 -0400
Date: Mon, 30 Aug 2010 15:56:36 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra 
	<public-peterz-wEGCiKHe2LqWVfeAwA7xHQ@plane.gmane.org>
Newsgroups: gmane.linux.kernel.kernel-testers,gmane.linux.kernel
Cc: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@plane.gmane.org>,
        Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Maciej Rutecki 
	<public-maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        "Zhang, Yanmin" 
	<public-yanmin_zhang-VuQAYsv1563Yd54FQh9/CA@plane.gmane.org>
Subject: Re: [Bug #16399] perf failed with kernel 2.6.35-rc
Message-ID: <20100830155636.23ef904b@schatten.dmk.lab>
In-Reply-To: <1283159563.1820.665.camel@laptop>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.XtC.eeueMB@chimera>
	<1283159563.1820.665.camel@laptop>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Aug 2010 11:12:43 +0200
Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Mon, 2010-08-30 at 01:13 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16399
> > Subject		: perf failed with kernel 2.6.35-rc
> > Submitter	: Zhang, Yanmin <yanmin_zhang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Date		: 2010-07-13 8:14 (48 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> > Message-ID	: <1279008849.2096.913.camel-sz7BYL/Y5Hu/P+R7jlPCFVaTQe2KTcn/@public.gmane.org>
> > References	: http://marc.info/?l=linux-kernel&m=127900880212470&w=2
> > 
> > 
> 
> Should be fixed by:
> 
> commit 351af0725e5222e35741011d1ea62215c1ed06db
> Author: Zhang, Yanmin <yanmin_zhang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Date:   Fri Aug 6 13:39:08 2010 +0800
> 
>     perf, x86: Fix Intel-nhm PMU programming errata workaround                                                                                                        

Thx, closed.

Cheers,
Flo

