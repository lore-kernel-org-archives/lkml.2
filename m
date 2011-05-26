Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1EZCKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:10:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:43858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab1EZCKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:10:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,270,1304319600"; 
   d="scan'208";a="5013779"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Jean Delvare <khali@linux-fr.org>, Andi Kleen <andi@firstfloor.org>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "jbeulich@novell.com" <jbeulich@novell.com>
Date: Wed, 25 May 2011 19:08:27 -0700
Subject: RE: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v2
Thread-Topic: [PATCH 3/3] coretemp: Get microcode revision from cpu_data v2
Thread-Index: AcwbHh1AY33x+JtYRGCdDm4HJFLcnQAK1cpw
Message-ID: <493994B35A117E4F832F97C4719C4C04011E2157D6@orsmsx505.amr.corp.intel.com>
References: <1306351948-23382-1-git-send-email-andi@firstfloor.org>
	<1306351948-23382-3-git-send-email-andi@firstfloor.org>
 <20110525225359.60d819d5@endymion.delvare>
In-Reply-To: <20110525225359.60d819d5@endymion.delvare>
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

> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: Wednesday, May 25, 2011 1:54 PM
> To: Andi Kleen
> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Andi Kleen;
> jbeulich@novell.com; Yu, Fenghua
> Subject: Re: [PATCH 3/3] coretemp: Get microcode revision from cpu_data
> v2
> 
> Hi Andi,
> 
> On Wed, 25 May 2011 12:32:28 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Now that the ucode revision is available in cpu_data remove
> > the existing code in coretemp.c to query it manually. Read the ucode
> > revision from cpu_data instead
> 
> Where is this available? Not upstream yet, apparently. I get a build
> failure here.
> 

This is one of three patches. Cpu_data is defined in the first patch. You need to get the other two to test them.

But I think Andi will send out a newer version with some changes. So we can test the newer patch set then.

Thanks.

-Fenghua
