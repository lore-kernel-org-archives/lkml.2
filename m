Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0HROVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:21:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60905 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab0HROVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:21:22 -0400
From: "Gopinath, Thara" <thara@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 18 Aug 2010 19:50:33 +0530
Subject: RE: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Thread-Topic: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Thread-Index: Acs+pVqwGMmza/oTT2e/huUx50UeEQAOv1/g
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB032422251A@dbde02.ent.ti.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB032422229C@dbde02.ent.ti.com>
 <20100818065905.GC11947@nokia.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB03242222C7@dbde02.ent.ti.com>
 <20100818071022.GD11947@nokia.com> <20100818071619.GE11947@nokia.com>
In-Reply-To: <20100818071619.GE11947@nokia.com>
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
>>From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
>>Sent: Wednesday, August 18, 2010 12:46 PM
>>To: Balbi Felipe (Nokia-MS/Helsinki)
>>Cc: Gopinath, Thara; Samuel Ortiz; linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org; Tony
>>Lindgren; Andrew Morton
>>Subject: Re: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
>>
>>Hi,
>>
>>On Wed, Aug 18, 2010 at 09:10:22AM +0200, Balbi Felipe (Nokia-MS/Helsinki) wrote:
>>>On Wed, Aug 18, 2010 at 09:03:44AM +0200, ext Gopinath, Thara wrote:
>>>>>>No I am not talking about the key values. I was talking about the register offset
>>>>>>for TWL4030_PM_MASTER_PROTECT_KEY. My question is, is it ok for it to be 0xd or 0xe.
>>>>>>Earlier we were using 0xd and in the new implementation it has been changed to 0xe.
>>>>
>>>>Typo. Earlier we were using 0xe and in the new implementation it has
>>>>been changed to 0xd.
>>>
>>>you're right, I'm not sure how I came up with that value since the TRM
>>>shows 0x0e, maybe a copy&paste error. Will change patch 1.
>>
>>ok, it's because there's no register 0x0a. And I missed that when
>>defined the register space. Good catch, thanks. I wonder why it didn't
>>fail to write to that register address :-?

0xd is a valid register offset. Hence no crash. Anyways I saw your new
patch. Looks ok to me.

Regards
Thara
