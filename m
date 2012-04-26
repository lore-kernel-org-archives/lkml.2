Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2DZAvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:51:48 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41575 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2DZAvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:51:47 -0400
Date: Thu, 26 Apr 2012 09:51:41 +0900
From: Norbert Preining <preining@logic.at>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120426005141.GA1869@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com> <20120413053858.GA4057@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD136757@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD136757@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Meenakshi,

On Mi, 25 Apr 2012, Venkataraman, Meenakshi wrote:
> >WIth that turned off I *believe* I have better results, but I will tet
> >it a bi tmore.
> 
> [MV] How is this looking now?

Definitely better. I still get occasional hickup but normally they
are just temporary, and no intervention is needed.

> [MV]  I'm going through this log -- don't have a root cause for this yet, but getting closer to it. I see in this log that authentication is timing out. It appears that the driver sent out the authentication frame, and received some frame OTA, but I can't tell what it received from just the dmesg log. I'd like some trace-cmd logs from you. Is it possible for you to collect a trace-cmd log and send over the binary to me?

WHat do you mean with trace-cmd? I don't have a "trace" utility installed,
only strace and ltrace AFAIR. And then, what should be traced?

> >One more thing, I believe that this happens most of the times
> >(but not necessarily exclusively, but I don't have statistics)
> >after resume (from suspend to ram).
> 
> [MV]  This is good to know. I wonder if this is related to the PCIe l used on your platform. Can you try to use PCIe link state management to L0s in your BIOS and see if the stability of your system improves?

This is a locked down bios from Sony, I can't get access to
these details, unfortunately.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
TIGHARRY (n.)
The accomplice or 'lure' who gets punters to participate in the three
card trick on London streets by winning an improbable amount of money
very easily.
			--- Douglas Adams, The Meaning of Liff
