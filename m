Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2LUIuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:50:24 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:62693 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab2LUIuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:50:19 -0500
Message-ID: <1356079817.1414.43.camel@x61.thuisdomein>
Subject: Re: [PATCH] [RFC] drm/radeon: return 0 on successful gpu reset
From: Paul Bolle <pebolle@tiscali.nl>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Christian =?ISO-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <jglisse@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Fri, 21 Dec 2012 09:50:17 +0100
In-Reply-To: <CADnq5_O_ezHcQPrW371_kJcgF==jc9NwmpN0tCy73eRPxgF9fg@mail.gmail.com>
References: <1355779884.1414.14.camel@x61.thuisdomein>
	 <50D0473D.9060106@vodafone.de>
	 <CADnq5_ORb_kdaehxR6y+P1S0eStiLEo7jFOYXhn4sMDw5b=bcw@mail.gmail.com>
	 <1355851688.1414.18.camel@x61.thuisdomein>
	 <CADnq5_O_ezHcQPrW371_kJcgF==jc9NwmpN0tCy73eRPxgF9fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Dec 2012 08:50:17.0692 (UTC) FILETIME=[337341C0:01CDDF58]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 13:37 -0500, Alex Deucher wrote:
> On Tue, Dec 18, 2012 at 12:28 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Tue, 2012-12-18 at 10:22 -0500, Alex Deucher wrote:
> >> On Tue, Dec 18, 2012 at 5:36 AM, Christian König
> >> <deathsimple@vodafone.de> wrote:
> >> > You should definitely try Alex latest drm-fixes-3.8 branch
> >> > (git://people.freedesktop.org/~agd5f/linux) since the possibility is quite
> >> > high that we already have fixed that bug. If that doesn't helps then please
> >> > open a bug report and leave me a note so that I can investigate further.
> >>
> >> I don't have a 3.8 fixes branch up just yet, but will soon.
> >
> > I see. I'll watch that repository, but I would appreciate it if you
> > notify me if that branch pops up.
> 
> http://cgit.freedesktop.org/~agd5f/linux/log/?h=drm-fixes-3.8

Thanks.

I tried drm-fixes-3.8, at commit
4613ca14b9739428abb53bef9cd0f8b3fee23a95 ("drm/radeon: add support for
MEM_WRITE packet"), on top of v3.7. It hangs in the exact same way.

Christian, were should I open a bug, and under which component, etc.?


Paul Bolle

