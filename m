Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab0EXWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623Ab0EXWvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:51:18 -0400
Subject: Re: [PATCH -next] nouveau: fix acpi_lid_open undefined
From: Dave Airlie <airlied@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
       linux-next@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
In-Reply-To: <4BFA8A71.4080900@oracle.com>
References: <20100522170459.4c89723d.sfr@canb.auug.org.au>
	 <20100523170040.3c4aa87c.randy.dunlap@oracle.com>
	 <20100524125628.GA14278@srcf.ucam.org> <4BFA84EF.7070609@oracle.com>
	 <20100524135940.GA15892@srcf.ucam.org>  <4BFA8A71.4080900@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 08:47:35 +1000
Message-ID: <1274741255.3416.1.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 07:17 -0700, Randy Dunlap wrote:
> On 05/24/10 06:59, Matthew Garrett wrote:
> > On Mon, May 24, 2010 at 06:53:51AM -0700, Randy Dunlap wrote:
> >> On 05/24/10 05:56, Matthew Garrett wrote:
> >>> Won't this result in a behavioural difference? The desirable outcome is 
> >>
> >> It could, yes.
> >>
> >>> that that configuration be impossible, not for that configuration to 
> >>> build but be buggy.
> >>
> >> so nouveau should depend on (or select, if ACPI is enabled) ACPI_BUTTON?
> > 
> > There's an argument that it doesn't need to depend on it, but if button 
> > is a module then nouveau has to be. Except the inverse isn't true. 
> > Kconfig is hard, let's weep gently.
> 
> Maybe Dave can weep with us when he is back at work...

Yeah I've had problems like this a few times lately with the drm, I'm
torn between just adding select all over the place, or assuming someone
sane is configuring the kernel.

I'm sort of erring on the someone sane is configuring the kernel just
because Linus's objects to "default y" things seems to point at that we
can't really give pointers to the people who haven't done it before. So
I'm quite happy to leave it having different behaviour depending on the
configuration and simply ignoring bug reports from incompetents.

Dave.


