Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2DIVmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:42:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:8324 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2DIVmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:42:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128876556"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
CC: "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Stornelli <marco.stornelli@gmail.com>
Subject: RE: [PATCH v5] ramoops: use pstore interface
Thread-Topic: [PATCH v5] ramoops: use pstore interface
Thread-Index: AQHNFpiE3OC67ZGsd0qw903LblBzkJaTBRsg
Date: Mon, 9 Apr 2012 21:42:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170D020E@ORSMSX104.amr.corp.intel.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
	<4F1A7854.7010808@gmail.com>	<1333399194.6431.3.camel@lorien2>
	<CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com>
 <20120409143345.a7a8c257.akpm@linux-foundation.org>
In-Reply-To: <20120409143345.a7a8c257.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch breaks ramoops module unloading.  Tony says there's "no
> credible end-user case" for this and Marco promptly provided one,
> which was ignored.

I'm not sure that I understood Marco's use case. He said:

> First of all ramoops was born mainly for debug purpose and
> to help the maintainability of a product. I used it in systems
> where the uptime (so no reboot) was important. So it can be
> very useful for me load the module, gather logs and unload it
> for example. A kernel panic is not recoverable so the reboot
> is needed but it's not always true for a kernel oops.

In the non-crashed oops case ... aren't all the logs you need
in /var/log/messages?

-Tony

