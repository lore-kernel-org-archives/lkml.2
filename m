Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab1BRBHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:07:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:3853 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1BRBG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:06:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,183,1297065600"; 
   d="scan'208";a="390508040"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Date: Thu, 17 Feb 2011 17:06:56 -0800
Subject: RE: [PATCH 3/3] ia64: drop custom exception table implementation
Thread-Topic: [PATCH 3/3] ia64: drop custom exception table implementation
Thread-Index: AcvOx27hP4WzYpDaSpe/um4hrMejygAQDegw
Message-ID: <987664A83D2D224EAE907B061CE93D53019D4BCC7B@orsmsx505.amr.corp.intel.com>
References: <4D5D631F0200007800032802@vpn.id2.novell.com>
 <20110217172321.GC17058@elte.hu>
In-Reply-To: <20110217172321.GC17058@elte.hu>
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

> Nice generalization of the exception code.

Yes - nice to see x86 finally catch up with ia64's compact exception tables :-)

> If Tony acks this patch then we can put the 3 patches into a separate -tip branch 
> and test it on x86 and push it into -next for ia64 testing. That would be the 
> simplest upstream merge route - if that's fine by Tony as well.

It *looks* ok. I didn't get time to try it out - but if it worked
on Jan's test system, then I'm fine to have it thrown into the linux-next
mix so I can pick it up with my regular linux-next tests.

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony
