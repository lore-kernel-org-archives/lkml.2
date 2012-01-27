Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2A0Bu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:50:29 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53735 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2A0Bu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:50:27 -0500
Date: Fri, 27 Jan 2012 10:50:15 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120127015015.GA23291@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at> <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com> <20120125002250.GA20431@gamma.logic.tuwien.ac.at> <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com> <20120126003735.GA2346@gamma.logic.tuwien.ac.at> <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com> <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com> <20120126232555.GB16330@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126232555.GB16330@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

On Fr, 27 Jan 2012, Norbert Preining wrote:
> First tests are promising, after reboot it was working immediately
> without need to rfkill block/unblock. lso after suspend and resume.
> 
> Will test more the next days and report back.

Unfortunately, at the university it is still a complete no-go.
Usually the connection works for a short time, then breaks down.
After that even unloading and loading the module did not reactivate
it, I cannot get a connection at all. But other units, or with
older kernel (it was 2.6.3X AFAIR) it was working without a glitch.

I uploaded a syslog output including kernel and network manager logs
to
	http://www.logic.at/people/preining/syslog.log
(new one). This shows a session from loading the module up to giving up.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
AITH (n.)
The single bristle that sticks out sideways on a cheap paintbrush.
			--- Douglas Adams, The Meaning of Liff
