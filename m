Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2GYDHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:07:41 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54748 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2GYDHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:07:39 -0400
Date: Wed, 25 Jul 2012 12:07:31 +0900
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
Message-ID: <20120725030731.GB8504@gamma.logic.tuwien.ac.at>
References: <20120413014047.GB25681@gamma.logic.tuwien.ac.at> <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <20120628072512.GF31944@gamma.logic.tuwien.ac.at> <1340869868.4491.4.camel@jlt3.sipsolutions.net> <20120628081607.GG31944@gamma.logic.tuwien.ac.at> <20120712081457.GA32465@gamma.logic.tuwien.ac.at> <1342109807.4531.38.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342109807.4531.38.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

Sorry for the late reply, I was travelling around the world ...
I have now tested the =2 and =4 settings at home, with the following
outcome:

On Do, 12 Jul 2012, Johannes Berg wrote:
> With the latest, I've extended 11n_disable to have more bits.
> 
> 11n_disable=1 will disable HT completely
> 11n_disable=2 will disable TX aggregation
> 11n_disable=4 will disable RX aggregation

11n_disabled=2:
lots of messages
  Open BA session requested for 00:0a:79:eb:56:10 tid 0
  BA request denied - HW unavailable for tid 0
and
  Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
  Rx A-MPDU request on tid 0 result 0

Connection is stable for quite some time, but after 1-2 hours I got
a bad hang, grinding to a halt. pings to kernel.org gives 26% 
packet loss, but the rest of the packets are fast 130ms 

(Isn't that a strange thing - 25+% packet loss and all others are fast?)
I assume the packaet loss is related to the above messages.


11n_disabled=4:

lots of messages
  Rx A-MPDU request on tid 0 result -22
and at some point ping timeouts of 80+ secs (!) and then total hang
(as far as I remember)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
PERRANZABULOE (n.)
One of those spray things used to wet ironing with.
			--- Douglas Adams, The Meaning of Liff
