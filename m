Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2BVCRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:17:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:3904 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2BVCRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:17:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109252986"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andrei.emeltchenko.news@gmail.com" 
	<andrei.emeltchenko.news@gmail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Topic: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Index: AQHM8Nu9391LFUTMFEuqxrbxHQK9JZZH4RQAgADIE4D//30WsIAAiTiA//98R1A=
Date: Wed, 22 Feb 2012 02:17:46 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18429B98A@ORSMSX102.amr.corp.intel.com>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
	 <1329857959.5143.11.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
	 <1329874581.5143.22.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>
 <1329875935.5143.24.camel@joe2Laptop>
In-Reply-To: <1329875935.5143.24.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1M2I24x022187

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, February 21, 2012 5:59 PM
> To: Allan, Bruce W
> Cc: David Miller; Andy Whitcroft; Andrew Morton;
> andrei.emeltchenko.news@gmail.com; linville@tuxdriver.com; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
> 
> On Wed, 2012-02-22 at 01:56 +0000, Allan, Bruce W wrote:
> > > On Tue, 2012-02-21 at 22:09 +0000, Allan, Bruce W wrote:
> > > > This appears to falsely complain about parenthesis alignment in
> > > > conditional statements with multiple opening parentheses.
> > > Can you try this one please?
> []
> > It's better, but there are still instances of false hits AFAICT.
> 
> Do you have any examples?
> The only one I noticed was spaces for alignment instead of tabs.
> I think that's not a false hit myself.
> 

Example 1:
	if (((a == b) ||
	     (c == d) ||
	     (e == f)) &&
	    (bool_var))
		baz();

Example 2:
	if ((!(var & FOO_MASK) &&
	     (a == b)) ||
	    (c == d))
		baz();

Example 3:
	if (!((foo & FOO_MASK) &&
	      (bar & BAR_MASK)))
		baz();

HTH,
Bruce.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
