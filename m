Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1K2Jch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:32:37 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49680 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1K2Jce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:32:34 -0500
References: <20111125122143.GA30404@gamma.logic.tuwien.ac.at> <CANUX_P1hFzSVPQzd6gq3tLY7hu+LX5suph6uHP+hq6+7rdAK1w@mail.gmail.com> <20111125123720.GA31564@gamma.logic.tuwien.ac.at> <CANUX_P2mGQX9H-f7OFusjUrv8ey56JNzFVEdKJkAejsg9zVNkQ@mail.gmail.com> <CANUX_P1aAz-4TpgSzQ2G=RkJOxXCAVQBja3GNsj_HpMNmqxeUw@mail.gmail.com> <1322387175.4044.16.camel@jlt3.sipsolutions.net> <CANUX_P3uoNOj3j-REvYCZP382cHfq+DpBRi7fnzFfMG_dyHtTQ@mail.gmail.com> <20111128035627.GH1422@gamma.logic.tuwien.ac.at> <CANUX_P2kYiFCP8uAhLZC_kVEjoyxabRBx3Pn+ndtFus=6hJN7Q@mail.gmail.com> <20111128042343.GA4619@gamma.logic.tuwien.ac.at> <20111128232525.GA12719@gamma.logic.tuwien.ac.at> <CANUX_P2b_ZYr4hHigA+tGa9uakcq3hQXnOiP5isQtfcYxCaxcw@mail.gmail.com> <1322555472.4110.8.camel@jlt3.sipsolutions.net> <CANUX_P0z9HmZSj_13Fv0LHUgy2UDXWMaj8L2Tgqz2jQC2mbpZw@mail.gmail.com>
In-Reply-To: <CANUX_P0z9HmZSj_13Fv0LHUgy2UDXWMaj8L2Tgqz2jQC2mbpZw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <F72258A2-71A1-4F82-B5ED-31FD2E837F3A@logic.at>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>
X-Mailer: iPhone Mail (9A405)
From: Norbert Preining <preining@logic.at>
Subject: Re: iwlagn is getting very shaky
Date: Tue, 29 Nov 2011 18:32:13 +0900
To: Emmanuel Grumbach <egrumbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> It might that we are holding the mac80211 workqueue in the driver too...
> I guess we could try to enable MAC80211 debug flag with timestamps to check.

Actually I got some strange behaviour today at work, but that might be a university temporary problem.

Let me know what I can send you?
I am currently using stock git plus that one patch.

If you want more patches send me them, and which module parameters.

All the best

Norbert

