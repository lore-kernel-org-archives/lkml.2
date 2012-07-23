Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2GWQLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:11:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:12655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2GWQLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:11:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="170231771"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: RE: [PATCH 2/2] x86/mce: Add quirk for instruction recovery on
 Sandy Bridge processors
Thread-Topic: [PATCH 2/2] x86/mce: Add quirk for instruction recovery on
 Sandy Bridge processors
Thread-Index: AQHNZnHeJaNmdoD6kECGRz5XAf2hOJczsIEBgANdlJA=
Date: Mon, 23 Jul 2012 16:11:03 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1936F3DB@ORSMSX104.amr.corp.intel.com>
References: <cover.1342723082.git.tony.luck@intel.com>
 <180a06f3f357cf9f78259ae443a082b14a29535b.1342723082.git.tony.luck@intel.com>
 <20120720121848.GA29183@aftab.osrc.amd.com>
 <CA+8MBbLX_cLR1+DpjuG-D5=5YhnTy3aGS4RL1iviRYomYoveWg@mail.gmail.com>
 <20120721124516.GB3632@aftab.osrc.amd.com>
In-Reply-To: <20120721124516.GB3632@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Other things which could probably be used are alternatives or jump
> labels but one if-test is simply not worth the complexity.

It might be if this were a super-hot path. But if you are getting so many machine
checks that you can see the effect of one extra "if" ... then you are hurting in
so many other ways!

> Oh well, enough games.

Thanks for the review.

-Tony
