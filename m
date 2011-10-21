Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1JUH0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 03:26:24 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:33844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1JUH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 03:26:22 -0400
Subject: Re: iwlagn is getting very shaky
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111021012354.GA26758@gamma.logic.tuwien.ac.at>
References: <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
	 <1319038282.25023.21.camel@wwguy-ubuntu>
	 <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 <1319096418.3959.1.camel@jlt3.sipsolutions.net>
	 <20111021012354.GA26758@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 09:26:13 +0200
Message-ID: <1319181973.3964.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-21 at 10:23 +0900, Norbert Preining wrote:

> > > [17419.285141] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (0)
> > > [17419.286583] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
> > > [17419.300296] cfg80211: Calling CRDA for country: JP
> > > [17419.309278] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
> > > [17419.310105] wlan0: authenticated
> > > [17419.317900] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
> > 
> > It seems a bit like the 5 GHz AP (:e0) just fails, and wpa_supplicant
> > selects a 2.4 GHz AP (:ef) now? Pure conjecture, I guess the AP could
> > also be on the same channel -- did you have scan information for these
> > APs?
> 
> BSS 00:24:c4:ab:bd:e0 (on wlan0)
>         freq: 2412

> And the one I am on:
> BSS 00:24:c4:ab:bd:ef (on wlan0) -- associated
>         freq: 5200

> No idea if that helps you.

Yes, thanks. So it's actually the other way around I guess.

I'm wondering if this too is related to the channel mess in mac80211.

johannes

