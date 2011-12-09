Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1LIXKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:10:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:5224 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1LIXKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:10:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94542694"
From: "Luck, Tony" <tony.luck@intel.com>
To: Petr Tesarik <ptesarik@suse.cz>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 9 Dec 2011 15:10:20 -0800
Subject: RE: Overlapping reserved regions at boot
Thread-Topic: Overlapping reserved regions at boot
Thread-Index: Acy066qv3STjH/2WS/W1cN2zsiAalAB26rRg
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EFB7B85@orsmsx508.amr.corp.intel.com>
References: <201111291501.51657.ptesarik@suse.cz>
 <201112071522.34034.ptesarik@suse.cz>
In-Reply-To: <201112071522.34034.ptesarik@suse.cz>
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

> OK guys, I take it that nobody is interested in ia64 any longer, but assuming 
> that there will probably be no other fix to the issue, can you at least 
> confirm that the fix is acceptable?

Sorry - way behind on my mail list reading.

It might be better to not make the overlap to begin with - but I can see
that would have a rather larger code impact.  So this looks good.

Queued for 3.3 merge

-Tony

