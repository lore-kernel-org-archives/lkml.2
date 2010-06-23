Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0FWDxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:53:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab0FWDxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:53:05 -0400
Date: Tue, 22 Jun 2010 20:52:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-mmc" <linux-mmc@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: MMC tree (Was: Re: [PATCH 1/2] MMC: fix all hangs related to
 mmc/sd card insert/removal during suspend/resume.)
Message-Id: <20100622205223.b84736c8.akpm@linux-foundation.org>
In-Reply-To: <20100623130837.eaa40f99.sfr@canb.auug.org.au>
References: <1276809695.28201.13.camel@maxim-laptop>
	<201006221119.06210.rjw@sisk.pl>
	<1277241450.10907.4.camel@maxim-laptop>
	<201006222353.21349.rjw@sisk.pl>
	<20100622152006.d0ec0cef.akpm@linux-foundation.org>
	<20100623130837.eaa40f99.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 13:08:37 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Tue, 22 Jun 2010 15:20:06 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 22 Jun 2010 23:53:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > >
> > > Andrew, who's maintaining MMC now?
> > 
> > Pierre stopped doing it, so I'm now pretending to.
> 
> So I guess I should remove the mmc tree (currently empty) from
> linux-next, then?

yup.

> > I actually pretend to maintain a huge number of subsystems and should
> > sprinkle akpms all over MAINTAINERS so stuff doesn't get lost.
> 
> How about splitting these subsystems out of -mm and adding them to
> linux-next?

Sigh.  Need to get onto that.  I suppose you'd prefer something that
actually compiles a bit, too.
