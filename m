Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2F1IQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 04:16:16 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41260 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2F1IQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 04:16:13 -0400
Date: Thu, 28 Jun 2012 17:16:07 +0900
From: Norbert Preining <preining@logic.at>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
        "Lin, Hsien KuoX" <hsien.kuox.lin@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [Ilw]  Re: 3.4-rc2, ilwagn still most of the time completely
	unusable
Message-ID: <20120628081607.GG31944@gamma.logic.tuwien.ac.at>
References: <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com> <20120413014047.GB25681@gamma.logic.tuwien.ac.at> <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <20120628072512.GF31944@gamma.logic.tuwien.ac.at> <1340869868.4491.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340869868.4491.4.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 28 Jun 2012, Johannes Berg wrote:
> Somehow your mail didn't make it to the lists, not sure why.

Hmm, yeah, some of the emails were privte exchange with 
Venkataraman and Lin.

> Fun. I don't actually see how this can possibly happen though?!

Hmm, actually I think I have seen similar things quite regularly,
and reported them also.

> > > > >   [ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active
> > > > >station id 0 addr 00:24:c4:ab:bd:e0
> > 
> > These messages now appear only now and then.
> 
> I fixed those recently.

Good.

> You seem to be on 3.5.0-rc now, is that really no different from 3.4?

The feeling is that it is definitely better.

I can actually work now wirelessly, and in case of hangs an rfkill block
rfkill unblock practically always, and mostly is not needed.

So yes, it is better, definitely.

I think till 3.4 I had to use the cable quite regularly.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
JAWCRAIG (n. medical)
A massive facial spasm which is brought on by being told a really
astounding piece of news. A mysterious attack of jawcraig affected
40,000 sheep in Whales in 1952.
			--- Douglas Adams, The Meaning of Liff
