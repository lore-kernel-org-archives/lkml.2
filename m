Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2L1Dfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 22:35:33 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:43036 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2L1Dfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 22:35:31 -0500
Date: Thu, 27 Dec 2012 21:35:27 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Minimum toolchain requirements?
To: Shaun Ruffell <sruffell@digium.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1355523910.18402.9@driftwood>
	<20121227200933.GC14257@digium.com>
In-Reply-To: <20121227200933.GC14257@digium.com> (from sruffell@digium.com
	on Thu Dec 27 14:09:33 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356665727.31232.15@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 02:09:33 PM, Shaun Ruffell wrote:
> Hi Rob,
> 
> On Fri, Dec 14, 2012 at 04:25:10PM -0600, Rob Landley wrote:
> > Although the README and Documentation/Changes both say the kernel
> > builds with gcc 3.2, this is no loner the case. In reality the new
> > 3.7 kernel no longer builds under unpatched gcc 4.2.1 (the last
> > GPLv2 release).
> >
> > Building for i686 breaks with
> > "arch/x86/kernel/cpu/perf_event_p6.c:22: error:
> > p6_hw_cache_event_ids causes a section type conflict" (trivial
> > workaround: patch kernel so CONFIG_BROKEN_RODATA defaults to y).
> 
> I came across your email while searching for a solution to the above
> build error.
> 
> In addition to setting CONFIG_BROKEN_RODATA=y, Jan Beulich sent a
> patch [1] to LKML that also fixes this build problem for me.
> 
> [1] https://lkml.org/lkml/2012/11/23/308
> 
> It doesn't appear to have hit Linus' tree yet though, but with luck
> someone will pick it up before 3.8 final.
> 
> Cheers,
> Shaun

Having it in 3.7.x would be nice too. Copying stable.

Thanks,

Rob