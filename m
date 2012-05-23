Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2EWBwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:52:40 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:20511 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2EWBwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:52:39 -0400
Subject: Re: [PATCH] gpu: schedule gma500 stub driver for feature removal
From: joeyli <jlee@suse.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <CADnq5_M7sSMhMM8ASJ-VOCdZBEx3yo3+P29WgwHRZ-Ls3zHoEA@mail.gmail.com>
References: <1337613303-12463-1-git-send-email-jlee@suse.com>
	 <CADnq5_M7sSMhMM8ASJ-VOCdZBEx3yo3+P29WgwHRZ-Ls3zHoEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 09:48:48 +0800
Message-ID: <1337737728.9751.236.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex, 

於 二，2012-05-22 於 12:01 -0400，Alex Deucher 提到：
> On Mon, May 21, 2012 at 11:15 AM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> > In v3.3, the gma500 drm driver moved from staging to drm group by
> > Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> > brightness well and don't need gma500 stub driver anymore.
> >
> > So, my plan is remove gma500 stub driver at Dec. 2012.
> 
> 
> December 2013?
> 
> Alex

My plan is December 2012, end of this year.


Thanks
Joey Lee

> >
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  Documentation/feature-removal-schedule.txt |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index a0ffac0..219d6f1 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -524,3 +524,14 @@ Files:     arch/arm/mach-at91/at91cap9.c
> >  Why:   The code is not actively maintained and platforms are now hard to find.
> >  Who:   Nicolas Ferre <nicolas.ferre@atmel.com>
> >        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > +
> > +----------------------------
> > +
> > +What:  Intel GMA500 Stub Driver
> > +When:  December 2012
> > +Why:   In v3.3, the gma500 drm driver moved from staging to drm group by
> > +       Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> > +       brightness well and don't need gma500 stub driver anymore.
> > +
> > +       So, my plan is remove gma500 stub driver at Dec. 2012.
> > +Who:   Lee, Chun-Yi <jlee@novell.com>
> > --
> > 1.6.0.2
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 


