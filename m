Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2ERQ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:57:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:34881 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab2ERQ5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:57:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168175920"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [git pull] machine check recovery fix
Thread-Topic: [git pull] machine check recovery fix
Thread-Index: AQHNNH7Tg8DRGfBqQ0uqmUy5M2GFI5bOsI78gAA0noyAAVKjAP//iwsw
Date: Fri, 18 May 2012 16:57:19 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F18E5@ORSMSX104.amr.corp.intel.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
 <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
 <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
 <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
 <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
 <CA+55aFygZYVpM7Agy+Vi+Majaa=7GLzeS8Mp9v3jiq-t+_=hLQ@mail.gmail.com>
 <CA+55aFxs1vcU08=7tEhmKRSRvjw5rUAqKfgWFPyta_qx7J7cog@mail.gmail.com>
In-Reply-To: <CA+55aFxs1vcU08=7tEhmKRSRvjw5rUAqKfgWFPyta_qx7J7cog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, having thought it over some more, I decided to do the pull.

Thanks.

> I still think MCE is confusing and actively buggy in many respects,
> and your RIPV check is much much too late, but with your patch it's no
> worse than it used to be.

Yes, it is confusing (and buggy ... VM86 mode check needs to be added
for one thing ... the special treatment of "ip == 0" is also bad). The
lookup table in mce-severity.c is there so that you can take the ".o"
from the kernel tree and link with some user mode sanity checking
tools in the mce-test toolset. Which I think is a step up from following
the pseudo-code in the SDM (which have their own bugs).

I'll try to make it better - but it is never going to be beautiful.

-Tony
