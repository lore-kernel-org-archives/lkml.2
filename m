Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab0HRHE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:04:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59510 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0HRHEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:04:20 -0400
From: "Gopinath, Thara" <thara@ti.com>
To: "Gopinath, Thara" <thara@ti.com>,
        "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 18 Aug 2010 12:33:44 +0530
Subject: RE: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Thread-Topic: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Thread-Index: Acs+ouRnZlZKFP6gQGCjQ3KrZujyxAAAD0FwAAARkwA=
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03242222C7@dbde02.ent.ti.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB032422229C@dbde02.ent.ti.com>
 <20100818065905.GC11947@nokia.com> 
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



>>-----Original Message-----
>>From: Gopinath, Thara
>>Sent: Wednesday, August 18, 2010 12:33 PM
>>To: 'felipe.balbi@nokia.com'
>>Cc: Samuel Ortiz; linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org; Tony Lindgren; Andrew
>>Morton
>>Subject: RE: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
>>
>>
>>
>>>>-----Original Message-----
>>>>From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
>>>>Sent: Wednesday, August 18, 2010 12:29 PM
>>>>To: Gopinath, Thara
>>>>Cc: Balbi Felipe (Nokia-MS/Helsinki); Samuel Ortiz; linux-kernel@vger.kernel.org; linux-
>>>>omap@vger.kernel.org; Tony Lindgren; Andrew Morton
>>>>Subject: Re: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
>>>>
>>>>On Wed, Aug 18, 2010 at 08:32:57AM +0200, ext Gopinath, Thara wrote:
>>>>>R_PROTECT_KEY offset is 0xE where as the new TWL4030_PM_MASTER_PROTECT_KEY
>>>>>is defined as 0xd. I have not checked the trm to see which is correct. But
>>>>
>>>>you can use either 0xc0|0x0c or 0xce|0xec, both will work are unlock
>>>>keys.
>>
>>No I am not talking about the key values. I was talking about the register offset
>>for TWL4030_PM_MASTER_PROTECT_KEY. My question is, is it ok for it to be 0xd or 0xe.
>>Earlier we were using 0xd and in the new implementation it has been changed to 0xe.

Typo. Earlier we were using 0xe and in the new implementation it has been changed to 0xd.

Regards
Thara
