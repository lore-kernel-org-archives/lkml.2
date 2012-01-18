Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2ARKpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:45:04 -0500
Received: from smtp.nokia.com ([147.243.1.47]:28752 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab2ARKpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:45:02 -0500
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>
CC: <riel@redhat.com>, <minchan@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <mel@csn.ul.ie>, <rientjes@google.com>, <kosaki.motohiro@gmail.com>,
        <hannes@cmpxchg.org>, <mtosatti@redhat.com>,
        <akpm@linux-foundation.org>, <rhod@redhat.com>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: RE: [RFC 1/3] /dev/low_mem_notify
Thread-Topic: [RFC 1/3] /dev/low_mem_notify
Thread-Index: AQHM1PAILpEwsgBJQ0+ebltvcfq8MpYQOdkAgAB3jICAACXvgIAA9v4A///6iYCAABO3AIAAA+QAgAARAJA=
Date: Wed, 18 Jan 2012 10:44:13 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
	<CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
In-Reply-To: <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Jan 2012 10:44:14.0431 (UTC) FILETIME=[1ED756F0:01CCD5CE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
> Pekka Enberg
> Sent: 18 January, 2012 12:40
...
> > Not worse than %%. For example you had 10% free memory threshold for
> > 512 MB RAM meaning 51.2 MB in absolute number.  Then hotplug turned
> > off 256 MB, you for sure must update threshold for %% because these
> > 10% for 25.6 MB most likely will be not suitable for different operating
> mode.
> > Using pages makes calculations must simpler.
> 
> Right. Does threshold in percentages make any sense then? Is it enough to
> use number of free pages?

Paul Mundt noticed that and we stopped use percentage in 2006 for n770 update. 
He was right.
Percents are useless and do not correlate with other kernel APIs like sysinfo().

