Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1GMMTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:19:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:16624 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1GMMTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:19:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,525,1304319600"; 
   d="scan'208";a="27171346"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Weil, Oren jer" <oren.jer.weil@intel.com>
Date: Wed, 13 Jul 2011 15:18:52 +0300
Subject: RE: [staging] mei: Enable msi when supported
Thread-Topic: [staging] mei: Enable msi when supported
Thread-Index: AcxAlZJLCmy45SR1QHic428u9bfCeQAwTagg
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F0401C71F565F@hasmsx504.ger.corp.intel.com>
References: <4E159945.8050900@gmail.com>
 <6F5C1D715B2DA5498A628E6B9C124F0401C711335D@hasmsx504.ger.corp.intel.com>
 <4E1C488A.1020308@gmail.com>
In-Reply-To: <4E1C488A.1020308@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Maarten Lankhorst [mailto:m.b.lankhorst@gmail.com]
> Sent: Tuesday, July 12, 2011 4:14 PM
> To: Winkler, Tomas
> Cc: devel@linuxdriverproject.org; Linux Kernel Mailing List; Weil, Oren jer
> Subject: Re: [staging] mei: Enable msi when supported
> 
> Hi Tomas,
> 
> On 07/07/2011 02:23 PM, Winkler, Tomas wrote:
> >> -----Original Message-----
> >> From: Maarten Lankhorst [mailto:m.b.lankhorst@gmail.com]
> >> Sent: Thursday, July 07, 2011 2:32 PM
> >> To: Winkler, Tomas
> >> Cc: devel@linuxdriverproject.org; Linux Kernel Mailing List
> >> Subject: [staging] mei: Enable msi when supported
> >>
> >> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> >> ---
> >> Tested suspend/resume, driver (re/un)loading. Comments welcome. :)
> > Sounds good, but I believe in case where MSI is enabled we also can kill the
> quick handler.
> > Let me check before I ack this.
> 
> Figured I'd bump because I haven't heard anything back.

Sorry  I was sick now I'm getting through my backlog 
Will have answers tomorrow.

Thanks
Tomas

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

