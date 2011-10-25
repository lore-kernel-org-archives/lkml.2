Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1JYSkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:40:01 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58555 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1JYSkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:40:00 -0400
Message-ID: <1319567946.17505.19.camel@work-vm>
Subject: Re: [PATCH 6/8] clocksource: m86knommu: Convert to
 clocksource_register_hz/khz
From: john stultz <johnstul@us.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gerg@snapgear.com>,
        uClinux development list <uclinux-dev@uclinux.org>
Date: Tue, 25 Oct 2011 11:39:06 -0700
In-Reply-To: <CAMuHMdWVdaq+uuCLxuN0EsmJiQdyr9xWpqg6oAeHg3NP_u2V8g@mail.gmail.com>
References: <4ea6fbe8.43310e0a.592c.5416SMTPIN_ADDED@mx.google.com>
	 <CAMuHMdWVdaq+uuCLxuN0EsmJiQdyr9xWpqg6oAeHg3NP_u2V8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11102518-3352-0000-0000-0000005FB6C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 20:35 +0200, Geert Uytterhoeven wrote:
> On Tue, Oct 25, 2011 at 20:08,  <y@kernel.beaverton.ibm.com> wrote:
> > From: John Stultz <johnstul@us.ibm.com>
> >
> > This converts the m86knommu clocksources to use clocksource_register_hz/khz
> >
> > This is untested, so any assistance in testing would be appreciated!
> >
> > CC: Geert Uytterhoeven <geert@linux-m68k.org>
> > CC: Greg Ungerer <gerg@uclinux.org>
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > ---
> >  arch/m68k/platform/68328/timers.c         |    4 +-
> >  arch/m68k/platform/coldfire/dma_timer.c   |    5 +-
> >  arch/m68knommu/platform/coldfire/pit.c    |  167 ++++++++++++++++++++++++++++
> >  arch/m68knommu/platform/coldfire/timers.c |  172 +++++++++++++++++++++++++++++
> >  4 files changed, 341 insertions(+), 7 deletions(-)
> >  create mode 100644 arch/m68knommu/platform/coldfire/pit.c
> >  create mode 100644 arch/m68knommu/platform/coldfire/timers.c
> 
> arch/m68knommu no longer exists.

Ah. My apologies. These patches have been around forever. Thanks for the
heads up.

thanks
-john

