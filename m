Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0KWHlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:41:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025Ab0KWHlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:41:18 -0500
Date: Mon, 22 Nov 2010 23:36:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Hannemann <arnd@arndnet.de>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-Id: <20101122233654.117eef93.akpm@linux-foundation.org>
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
	<20101118082454.GC15928@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
	<4CEAA151.7050404@arndnet.de>
	<20101123063200.GA23907@elte.hu>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 07:32:19 +0000 "Berg, Johannes" <johannes.berg@intel.com> wrote:

> 
> > > I also ran into this today.
> > > Any updates or pointer to the patch?
> > 
> > Same here - i'm running into this build bug frequently as well, as of
> > 2.6.37-rc3.
> > Please guys at minimum post the pending fix for this.
> 
> Hmm. For some reason I thought this patch had made it into -mm,
> but I never double-checked and then went travelling ...
> 
> http://lkml.org/lkml/2010/10/26/79

oops, I filed it in the wrong drawer, under "non-urgent".  It then got
buried in new paperwork.  But not lost!

Gee it's big.  Could you please double-check that it is still complete?

