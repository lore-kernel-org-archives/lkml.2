Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1HWUPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:15:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:36214 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab1HWUPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:15:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41105299"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Aug 2011 13:15:40 -0700
Subject: RE: using mce_inject I get: RIP 10:<ffffffffa012c909>
 {ttm_bo_unref+0xf/0x45 [ttm]}
Thread-Topic: using mce_inject I get: RIP 10:<ffffffffa012c909>
 {ttm_bo_unref+0xf/0x45 [ttm]}
Thread-Index: Acxhvsv6lIikFZZ6SOyb+5J71AXZKwAEhJ4w
Message-ID: <987664A83D2D224EAE907B061CE93D5301EA5B717B@orsmsx505.amr.corp.intel.com>
References: <4E506DEA.1070601@gmail.com>
 <20110821221602.GK25996@one.firstfloor.org> <4E53EB01.7080905@gmail.com>
In-Reply-To: <4E53EB01.7080905@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> its easily fixable, but not sure its a good idea due to bisect going 
> through commits(afraid I might go astray with the bisect if I add any 
> patches).

Rather than fixing a bad build - you can try moving to a nearby commit
(use "gitk" to get a view of the structure around the commit that git
bisect suggested).  In the early stages of a bisection, it doesn't really
matter much if you build the mid-point that bisect provided, or some
nearby on - just be sure to mark good/bad the commit you actually built.

-Tony

