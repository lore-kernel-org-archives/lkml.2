Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab2AEQOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:14:18 -0500
Received: from smtp.nokia.com ([147.243.1.48]:41029 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab2AEQOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:14:17 -0500
From: <leonid.moiseichuk@nokia.com>
To: <gregkh@suse.de>
CC: <penberg@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cesarb@cesarb.net>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <emunson@mgebm.net>, <aarcange@redhat.com>, <riel@redhat.com>,
        <mel@csn.ul.ie>, <rientjes@google.com>, <dima@android.com>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Topic: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and
 related changes in MM
Thread-Index: AQHMyxrzN1IXGAcozUyLCM5upAjFdpX9o6HwgAAD5oCAABMyQIAAExqAgAAjOZA=
Date: Thu, 5 Jan 2012 16:13:27 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045545E5@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195612.GB19181@suse.de>
 <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLEdTMB6JtYViRJq5gZ4_w5aaV18S3q-1rOXGzaMtmiW6A@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB9826904554391@008-AM1MPN1-003.mgdnok.nokia.com>
 <20120105145753.GA3937@suse.de>
In-Reply-To: <20120105145753.GA3937@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Jan 2012 16:13:28.0060 (UTC) FILETIME=[F58D2BC0:01CCCBC4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: ext Greg KH [mailto:gregkh@suse.de] 
>No, please listen to what people, including me, are saying, otherwise your code will be totally ignored.

I tried to sort out all inputs coming. But before doing the next step I prefer to have tests passed. Changes you proposed are strain forward and understandable. 
Hooking in mm/vmscan.c and mm/page-writeback.c is not so easy, I need to find proper place and make adequate proposal.
Using memcg is doesn't not look for me now as a good way because I wouldn't like to change memory accounting - memcg has strong reason to keep caches.

Best Wishes,
Leonid
