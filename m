Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0KWIHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:07:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab0KWIG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:06:59 -0500
Date: Tue, 23 Nov 2010 00:02:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
        Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-Id: <20101123000232.e51b99b7.akpm@linux-foundation.org>
In-Reply-To: <20101123075742.GA28714@elte.hu>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
	<20101118082454.GC15928@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
	<4CEAA151.7050404@arndnet.de>
	<20101123063200.GA23907@elte.hu>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
	<20101122233654.117eef93.akpm@linux-foundation.org>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
	<20101123075742.GA28714@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 08:57:42 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Berg, Johannes <johannes.berg@intel.com> wrote:
> 
> > > > Hmm. For some reason I thought this patch had made it into -mm,
> > > > but I never double-checked and then went travelling ...
> > > >
> > > > http://lkml.org/lkml/2010/10/26/79
> > > 
> > > oops, I filed it in the wrong drawer, under "non-urgent".  It then got
> > > buried in new paperwork.  But not lost!
> > > 
> > > Gee it's big.  Could you please double-check that it is still complete?
> > 
> > Will do. I suspect it should, unless you took new LED drivers? But then
> > again you will now probably want a patch against -rc, not -mm?
> 
> It applied with a fuzz here so something changed in that file since you made the 
> patch. I did a quick review of drivers/leds/Kconfig and your patch seems complete to 
> me.

It looks complete to me as well.  It already fixes LEDS_NETXBIG.
