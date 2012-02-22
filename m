Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2BVJf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:35:58 -0500
Received: from mx0.aculab.com ([213.249.233.131]:37833 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754432Ab2BVJf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:35:56 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Date: Wed, 22 Feb 2012 09:35:14 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E77@saturn3.aculab.com>
In-Reply-To: <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] checkpatch: Add some --strict coding style checks
Thread-Index: AQHM8Nu9391LFUTMFEuqxrbxHQK9JZZH4RQAgADHRwA=
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Joe Perches" <joe@perches.com>, "David Miller" <davem@davemloft.net>,
        "Andy Whitcroft" <apw@shadowen.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: <andrei.emeltchenko.news@gmail.com>, <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Feb 2012 09:35:14.0999 (UTC) FILETIME=[48016470:01CCF145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 	if (!(func_a(x) &&
> 		func_b(y)))
> 		baz();

Gah - that is horrid for the 'preferred style'.
A quick glance at the code puts both the func_b()
and baz() calls as inside the if.

	David


