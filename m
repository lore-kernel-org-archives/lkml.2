Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066Ab2DMBkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 21:40:53 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36907 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935044Ab2DMBkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 21:40:52 -0400
Date: Fri, 13 Apr 2012 10:40:47 +0900
From: Norbert Preining <preining@logic.at>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120413014047.GB25681@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fr, 13 Apr 2012, Venkataraman, Meenakshi wrote:
> [MV] Well...actually don't turn off this debugging yet.

Ok, just compiled and rebooted with new git checkout, but will recompile
with option again enabled.

> In your logs I also see missed beacon notifications from the firmware ~every 500 milliseconds. My thought is that it is probably due to turning on power save. I'm not sure if it is affecting the performance of your system overall. Are you using the power save option? And if so, what is the behaviour when power save is turned off?

I am not sure what you mean with power safe of the iwl driver. If I do
	iwconfig wlan0
I see
	Power Management:off
is this what you mean, and 
	$ cat /sys/class/ieee80211/phy2/power/runtime_enabled
	disabled
Is it what you mean?

> I don't see the invalid station activation error in the log you sent me, so I'm guessing it appears only on the other network. Do send us logs for that. 

Yes, that is on a differnet network. As soon as I can catch the log I 
send it.

> If you're up for it, I'd ask you to do one thing  (or three) -- open 3 separate bugs for the issues you're seeing at: bugzilla.intellinuxwireless.org so we can keep track of them separately. The issue of trying to activate an invalid station ID is definitely a new one, and likely due to a different cause than that related to aggregation or the troubles you're having even with 11n disabled. I could do this too, and add you to the CC list. I might need logs for these bugs, but not yet.

Sure, will do that.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
ESHER (n.)
One of those push tapes installed in public washrooms enabling the
user to wash their trousers without actually getting into the
basin. The most powerful esher of recent years was 'damped down' by
Red Adair after an incredible sixty-eight days' fight in Manchester's
Piccadilly Station.
			--- Douglas Adams, The Meaning of Liff
