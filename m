Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3AGIGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab3AGIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:06:12 -0500
Date: Mon, 7 Jan 2013 09:05:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
Message-ID: <20130107080532.GA2984@redhat.com>
References: <20121228190352.097882544@decadent.org.uk>
 <50DEA41E.6010409@01019freenet.de>
 <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
 <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 01:42:37PM +0100, Ben Hutchings wrote:
> On Sun, 2012-12-30 at 13:38 +0100, Ben Hutchings wrote:
> > On Sat, 2012-12-29 at 09:04 +0100, Andreas Hartmann wrote:
> > > Ben Hutchings wrote:
> > > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Andreas Hartmann <andihartmann@01019freenet.de>
> > > > 
> > > > commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f upstream.
> > > 
> > > [...]
> > > 
> > > This patch is a workaround for
> > > 
> > > mac80211: retry sending failed BAR frames later instead of tearing down
> > > aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html -
> > > f0425beda4d404a6e751439b562100b902ba9c98)
> > > See:
> > > http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=83304
> > > 
> > > 
> > > Meanwhile there was a bug report complaining about problems with
> > > be03d4a45 when used as STA:
> > > http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/1257
> > > You can find there a few other workaround proposals.
> > [...]
> > 
> > OK, I'll drop this for now.  Once this is sorted out, please send to
> > stable a complete list of fixes that are needed.
> 
> To be clear, I have all of these in the queue:
> 
> be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
> 5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
> ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
> 
> and I'm intending to drop/defer them all.

Patch 3 is a revert of patch 1 (questioned patch). Please apply all 3 patches,
or only patch 2.

Stanislaw
