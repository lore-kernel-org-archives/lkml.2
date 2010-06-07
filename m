Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0FGSQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:16:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:7776 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0FGSQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:16:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,379,1272870000"; 
   d="scan'208";a="574102222"
From: "Luck, Tony" <tony.luck@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Young <hidave.darkstar@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 7 Jun 2010 11:16:36 -0700
Subject: RE: linux-next: Tree for June 3
Thread-Topic: linux-next: Tree for June 3
Thread-Index: AcsEY+O0ZiczF1FsQaaV8RvLZOOyjgCCSZQw
Message-ID: <987664A83D2D224EAE907B061CE93D530114F86372@orsmsx505.amr.corp.intel.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
 <201006051209.51664.rusty@rustcorp.com.au>
 <201006051221.38088.rusty@rustcorp.com.au>
 <201006051331.26359.rusty@rustcorp.com.au>
In-Reply-To: <201006051331.26359.rusty@rustcorp.com.au>
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

> This time for sure!

Something very like that patch showed up in next-20100607 ... so
I took that for a spin. Everything seems tickety-boo. Modules get
loaded with no OOPSen. All my devices are found and working.

Thanks

-Tony
