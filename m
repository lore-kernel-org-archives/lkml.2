Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2L0GtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 01:49:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:57801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab2L0GtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 01:49:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,361,1355126400"; 
   d="scan'208";a="237098979"
From: "He, Bo" <bo.he@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
CC: Randy Dunlap <rdunlap@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Subject: RE: [PATCH V2] output the cpu number  when printking.
Thread-Topic: [PATCH V2] output the cpu number  when printking.
Thread-Index: AQHN4f9slgE7yOOjh0+uBtjAW7KNHJgoLsKAgAKqAQCAAV0vcA==
Date: Thu, 27 Dec 2012 06:49:13 +0000
Message-ID: <CD6925E8781EFD4D8E11882D20FC406D1D2A08@SHSMSX101.ccr.corp.intel.com>
References: <1356316276.2385.7.camel@hebo> <50D7CDED.4060308@infradead.org>
 <1356321255.2385.8.camel@hebo> <1356325315.2385.74.camel@hebo>
 <20121224175532.GA15041@kroah.com>
 <1356397745.2638.21.camel@ymzhang.sh.intel.com>
 <20121226175004.GA23250@kroah.com>
In-Reply-To: <20121226175004.GA23250@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBR6nLUg019443

Thanks, Greg.
I did use this patch to fix many races on SMP. But to respect maintainer, I stop pushing the patch to upstream.


-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Thursday, December 27, 2012 1:50 AM
To: Yanmin Zhang
Cc: He, Bo; Randy Dunlap; akpm@linux-foundation.org; mingo@elte.hu; linux-kernel@vger.kernel.org; a.p.zijlstra@chello.nl
Subject: Re: [PATCH V2] output the cpu number when printking.

On Tue, Dec 25, 2012 at 09:09:05AM +0800, Yanmin Zhang wrote:
> On Mon, 2012-12-24 at 09:55 -0800, Greg KH wrote:
> > On Mon, Dec 24, 2012 at 01:01:55PM +0800, he, bo wrote:
> > > From: "he, bo" <bo.he@intel.com>
> > > 
> > > We often hit kernel panic issues on SMP machines because processes 
> > > race on multiple cpu. By adding a new parameter printk.cpu, kernel 
> > > prints cpu number at printk information line. Itâ€™s useful to debug 
> > > what cpus are racing.
> > 
> > How useful is this really for normal developers?
> It's very useful to debug race conditions under SMP environment.
> We applied the patch to our Android build image on our smartphones.

That's fine for your application, and seemed to be useful to others with their first interactions with SMP systems.  However, once you start to get to "real" numbers of CPUs, this information turns pretty pointless, which is why the patch was originally rejected.

sorry,

greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
