Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2AIKUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:20:53 -0500
Received: from smtp.nokia.com ([147.243.1.48]:30182 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2AIKUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:20:52 -0500
From: <leonid.moiseichuk@nokia.com>
To: <rientjes@google.com>
CC: <gregkh@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cesarb@cesarb.net>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <emunson@mgebm.net>, <penberg@kernel.org>, <aarcange@redhat.com>,
        <riel@redhat.com>, <mel@csn.ul.ie>, <dima@android.com>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
Thread-Topic: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
Thread-Index: AQHMyxrzw3V52zxEQkmaiNpKEK9QnpYDzM3g///5tgCAABJ9kA==
Date: Mon, 9 Jan 2012 10:19:30 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904554B81@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <ed78895aa673d2e5886e95c3e3eae38cc6661eda.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195521.GA19181@suse.de>
 <84FF21A720B0874AA94B46D76DB9826904554AFD@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jan 2012 10:19:37.0352 (UTC) FILETIME=[30B73880:01CCCEB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext David Rientjes [mailto:rientjes@google.com]
> Sent: 09 January, 2012 12:09
...
> 
> I'm not sure why you need to detect low memory thresholds if you're not
> interested in using the memory controller, why not just use the oom killer
> delay that I suggested earlier and allow userspace to respond to conditions
> when you are known to failed reclaim and require that something be killed?

As I understand that is required to turn on memcg and memcg is a thing I try to avoid.

> > 1.7. David Rientjes
> > > This is just a side-note but as this information is meant to be
> > > consumed by userspace you have the option of hooking into the
> > > mm_page_alloc tracepoint. You get the same information about how
> > > many pages are allocated or freed. I accept that it will probably be a bit
> slower but on the plus side it'll be backwards compatible and you don't need
> a kernel patch for it.
> >
> 
> I didn't write that.

Sorry, it was Mel Gorman. Copy-paste problem.
