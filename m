Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3AGIiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:38:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab3AGIiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:38:20 -0500
Date: Mon, 7 Jan 2013 09:37:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
Message-ID: <20130107083752.GD2984@redhat.com>
References: <20121228190352.097882544@decadent.org.uk>
 <50DEA41E.6010409@01019freenet.de>
 <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
 <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>
 <20130107080532.GA2984@redhat.com>
 <20130107081821.GF27909@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107081821.GF27909@elie.Belkin>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 12:18:21AM -0800, Jonathan Nieder wrote:
> Stanislaw Gruszka wrote:
> > On Sun, Dec 30, 2012 at 01:42:37PM +0100, Ben Hutchings wrote:
> 
> >> To be clear, I have all of these in the queue:
> >>
> >> be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
> >> 5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
> >> ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
> >>
> >> and I'm intending to drop/defer them all.
> >
> > Patch 3 is a revert of patch 1 (questioned patch). Please apply all 3 patches,
> > or only patch 2.
> 
> Despite its title, isn't patch 3 not exactly a revert?  It includes a
> change that depends on patch 2.  I don't think patch 2 alone would
> have any effect.

Yes, all 3 patches should go in.

Stanislaw
