Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab2AROss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 09:48:48 -0500
Received: from smtp.nokia.com ([147.243.128.24]:42939 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715Ab2AROsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 09:48:47 -0500
From: <leonid.moiseichuk@nokia.com>
To: <gregkh@suse.de>, <penberg@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <cesarb@cesarb.net>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <emunson@mgebm.net>,
        <aarcange@redhat.com>, <riel@redhat.com>, <mel@csn.ul.ie>,
        <rientjes@google.com>, <dima@android.com>, <rebecca@android.com>,
        <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH v2 1/2] Making si_swapinfo exportable
Thread-Topic: [PATCH v2 1/2] Making si_swapinfo exportable
Thread-Index: AQHM1czCowNffkIo8UaHnjXkgi379pYSGRoAgAAaglA=
Date: Wed, 18 Jan 2012 14:47:47 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045599D8@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1326803859.git.leonid.moiseichuk@nokia.com>
 <56cc3c5d40a8653b7d9bef856ff02d909b98f36f.1326803859.git.leonid.moiseichuk@nokia.com>
 <CAOJsxLHfHHrFyhfkSe8mbsnJHBkgKtksCZZDwN6K3d7KJqfzkQ@mail.gmail.com>
 <20120118140904.GB13817@suse.de>
In-Reply-To: <20120118140904.GB13817@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Jan 2012 14:47:48.0424 (UTC) FILETIME=[2575B480:01CCD5F0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext Greg KH [mailto:gregkh@suse.de]
> Sent: 18 January, 2012 16:09
...

> > > +EXPORT_SYMBOL(si_swapinfo);
> 
> EXPORT_SYMBOL_GPL() perhaps?

I followed si_meminfo which is uses EXPORT_SYMBOL. 
