Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab1LNEN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:13:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:18424 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab1LNENx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:13:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101956484"
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111214015959.GA6276@thunk.org>
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
	 <1323800557.3355.31.camel@jlt3.sipsolutions.net>
	 <20111213201752.GA5094@thunk.org>  <20111214015959.GA6276@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 19:14:30 -0800
Message-ID: <1323832470.13074.224.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,
On Tue, 2011-12-13 at 17:59 -0800, Ted Ts'o wrote:
> On Tue, Dec 13, 2011 at 03:17:52PM -0500, Ted Ts'o wrote:
> > Well, this patch seems to fix things for the non-authenticated case.
> > I can now associate with the GoogleGuest SSID without any problems.
> > I'm still having problems associating with the EAP-TLS encrypted
> > network, but that looks like it's a different bug.  (And that may
> > explain why I had so much trouble bisecting this; there are two issues
> > that have very similar symptoms.)
> 
> ... and the second problem I had with associating with EAP-TLS
> encrypted SSID's was solved by Wey-Yi's patch: 
> 
> 	  iwlwifi: allow to switch to HT40 if not associated yet
> 
> ... found in the thread "iwlagn regression in v3.1.5"
> 
> So with these two patches applied, things are now stable for me.
> 
> One thing: out of curiosity, I assume there is a pretty good testing
> infrastructure at Intel --- how was it that this didn't caught
> earlier?  Is it because different access points do things a little
> different?  Would it be useful if I can find out the model of access
> point that we're using, so you could hopefully augment your library of
> test hardware?  I'm asking out of purely selfish reasons, of course,
> since this took me the better part of a day to bisect each of these
> problems.

You ask a very valid and good question, you are correct, we at Intel
have a very good lab and great testing infrastructure. But at the same
time, there are so many APs available on the market and each one could
behave differently, also just like station, AP's software continue
change and improve, and at the same time, bugs can be introduced. We try
to do our best, but we can not cover everything and we truly hope the
community can help us flush the corner cases and bugs we miss.

Yes, if you can let us know your configuration and the AP information,
it will be very helpful. But please do help us continue test our latest
driver, so we can improve our driver quality and better serve the
community.

Thanks
Wey 


