Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1ATPIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:08:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:12388 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab1ATPIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:08:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,351,1291622400"; 
   d="scan'208";a="377397668"
From: "Anvin, H Peter" <h.peter.anvin@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 20 Jan 2011 07:08:07 -0800
Subject: RE: Linux 2.6.38-rc1 doesn't boot
Thread-Topic: Linux 2.6.38-rc1 doesn't boot
Thread-Index: Acu4lM1UQClXhK9pRu202feH4TSPIgAHutAg
Message-ID: <ADDEBCD9C145E542A8688C29F1FBDCB9C915F59E@orsmsx502.amr.corp.intel.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119073905.GA1652@gentoo.trippels.de>
 <20110119074902.GA1670@gentoo.trippels.de>
 <1295424766.1949.879.camel@sli10-conroe> <4D36A759.60704@intel.com>
 <20110119090904.GA4927@elte.hu> <1295489286.1949.882.camel@sli10-conroe>
 <20110120112541.GA23661@elte.hu>
In-Reply-To: <20110120112541.GA23661@elte.hu>
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

(The patch will need to be paired with removing the hacks in the linker script.)

-----Original Message-----
From: Ingo Molnar [mailto:mingo@elte.hu] 
Sent: Thursday, January 20, 2011 3:26 AM
To: Li, Shaohua
Cc: Anvin, H Peter; Markus Trippelsdorf; Lu, Hongjiu; Linus Torvalds; Linux Kernel Mailing List; Sam Ravnborg
Subject: Re: Linux 2.6.38-rc1 doesn't boot


* Shaohua Li <shaohua.li@intel.com> wrote:

> it's not a build failure, without it, my i386 kernel can't boot
> actually.

Please try hpa's patch in this thread on top of very latest (today's) -git or latest 
-tip:

   http://people.redhat.com/mingo/tip.git/README

Does that result in a booting system? That way we can avoid most of the linker 
script madness.

Thanks,

	Ingo
