Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1LADRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:17:48 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55804 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1LADRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:17:46 -0500
Date: Thu, 1 Dec 2011 12:17:08 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111201031708.GE4644@gamma.logic.tuwien.ac.at>
References: <1322387175.4044.16.camel@jlt3.sipsolutions.net> <CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com> <20111128035627.GH1422@gamma.logic.tuwien.ac.at> <CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com> <20111128042343.GA4619@gamma.logic.tuwien.ac.at> <20111128232525.GA12719@gamma.logic.tuwien.ac.at> <CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com> <1322555472.4110.8.camel@jlt3.sipsolutions.net> <CANUX_P0z9HmZSj_13Fv0LHUgy2UDXWMaj8L2Tgqz2jQC2mbpZw@mail.gmail.com> <F72258A2-71A1-4F82-B5ED-31FD2E837F3A@logic.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F72258A2-71A1-4F82-B5ED-31FD2E837F3A@logic.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 29 Nov 2011, Norbert Preining wrote:
> > It might that we are holding the mac80211 workqueue in the driver too...
> > I guess we could try to enable MAC80211 debug flag with timestamps to check.
> 
> Actually I got some strange behaviour today at work, but that might be a university temporary problem.

Yeah, I have to say that the situation is much better, but not solved.
Today I got a completely stuch driver again. I will reactivate debugging
and see what I get.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
...[Arthur] leapt to his feet like an author hearing the
phone ring...
                 --- Who says that the character of Arthur isn't
                 --- autobiographical?
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
