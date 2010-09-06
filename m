Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0IFKnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:43:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0IFKnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:43:06 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jean Pihet <jean.pihet@newoldbits.com>, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Mon, 6 Sep 2010 12:42:59 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com> <20100904081801.GA19876@elte.hu> <AANLkTinrRoi6y1fKUevu2O-Diac5B2r8RftTWUigQZOh@mail.gmail.com>
In-Reply-To: <AANLkTinrRoi6y1fKUevu2O-Diac5B2r8RftTWUigQZOh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009061243.00479.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 September 2010 10:56:50 Jean Pihet wrote:
> Hi,
> 
> Thanks for the feedback!
> 
> > On Friday 03 September 2010 21:55:55 Ingo Molnar wrote:
> >Well, the patch that got posted:
> >
> > [PATCH] tracing, perf: add more power related events
> >
> >Only adds tracepoints to power.h, but doesnt actually use them anywhere
> >...
> >
> >Is there a companion patch i missed?
> I will re-start a thread with the full patch and with both lkml and
> linux-omap in Cc.
discuss@lesswatts.org and linux-pm@lists.linux-foundation.org
are also lists where people could be interested in such stuff.

Could you explain a bit what these ARM specific power domains are then, please.

One idea I had after seeing these:
Would it make sense to additionally add one or several device power perf event(s)?
bluetooth, wireless, usb, cameras, whatever, could register it by name,
like you've done it with the power domains.
E.g. I had a problem with 2.6.31 where bluetooth was powered up/activated at
boot time, while it got activated ondemand before. Cost me some Watts and quite
some time to find that out.
Showing perf power events when bluetooth gets activated and put into lower power
states again (and the same for other devices), sounds like a good idea?

     Thomas
