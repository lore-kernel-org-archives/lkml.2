Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LDBCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 20:02:06 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:59647 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1LDBCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 20:02:04 -0500
Date: Sun, 4 Dec 2011 02:02:00 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Alex, Shi" <alex.shi@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>, tj@kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111204010200.GA1530@x4.trippels.de>
References: <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121153621.GA1678@x4.trippels.de>
 <20111123160353.GA1673@x4.trippels.de>
 <alpine.DEB.2.00.1111231004490.17317@router.home>
 <20111124085040.GA1677@x4.trippels.de>
 <20111202230412.GB12057@homer.localdomain>
 <20111203092845.GA1520@x4.trippels.de>
 <CAPM=9tyjZc9waC_ZBygW9zh+Zq-Wb1X5Y6yfsCCMPYwpFVWOOg@mail.gmail.com>
 <20111203122900.GA1617@x4.trippels.de>
 <CAH3drwZDOpPuQ_G=LwTiNsR5BNyJTNr+VJU74E6nS5AbKyQH0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH3drwZDOpPuQ_G=LwTiNsR5BNyJTNr+VJU74E6nS5AbKyQH0A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.12.03 at 14:31 -0500, Jerome Glisse wrote:
> On Sat, Dec 3, 2011 at 7:29 AM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2011.12.03 at 12:20 +0000, Dave Airlie wrote:
> >> >> > > > > FIX idr_layer_cache: Marking all objects used
> >> >> > > >
> >> >> > > > Yesterday I couldn't reproduce the issue at all. But today I've hit
> >> >> > > > exactly the same spot again. (CCing the drm list)
> >>
> >> If I had to guess it looks like 0 is getting written back to some
> >> random page by the GPU maybe, it could be that the GPU is in some half
> >> setup state at boot or on a reboot does it happen from a cold boot or
> >> just warm boot or kexec?
> >
> > Only happened with kexec thus far. Cold boot seems to be fine.
> >
> > --
> > Markus
> 
> Can you add radeon.no_wb=1 to your kexec kernel paramater an see if
> you can reproduce.

No, I cannot reproduce the issue with radeon.no_wb=1. (I write this
after 700 successful kexec iterations...)

-- 
Markus
