Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0HRK0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:26:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39476 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab0HRK0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:26:34 -0400
From: "Gopinath, Thara" <thara@ti.com>
To: Andy Whitcroft <apw@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Aug 2010 15:56:26 +0530
Subject: RE: Checkpatch false positive in 2.6.36-rc1.
Thread-Topic: Checkpatch false positive in 2.6.36-rc1.
Thread-Index: Acs+vwHMQUA7DTALQs+uAa2flZWUOgAAJ/oQ
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03242223FA@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0324222271@dbde02.ent.ti.com>
 <20100818102033.GP6193@shadowen.org>
In-Reply-To: <20100818102033.GP6193@shadowen.org>
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
>>From: Andy Whitcroft [mailto:apw@canonical.com]
>>Sent: Wednesday, August 18, 2010 3:51 PM
>>To: Gopinath, Thara
>>Cc: linux-kernel@vger.kernel.org
>>Subject: Re: Checkpatch false positive in 2.6.36-rc1.
>>
>>On Wed, Aug 18, 2010 at 11:34:51AM +0530, Gopinath, Thara wrote:
>>> Hello Andy,
>>>
>>> The following is my patch.
>>>
>>> Index: linux-omap-pm/arch/arm/plat-omap/Kconfig
>>> ===================================================================
>>> --- linux-omap-pm.orig/arch/arm/plat-omap/Kconfig
>>> +++ linux-omap-pm/arch/arm/plat-omap/Kconfig
>>> @@ -37,7 +37,7 @@ config OMAP_DEBUG_LEDS
>>>
>>>  config OMAP_SMARTREFLEX
>>>         bool "SmartReflex support"
>>> -       depends on ARCH_OMAP3 && PM
>>> +       depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
>>>         help
>>>           Say Y if you want to enable SmartReflex.
>>>
>>>
>>> And the following is the check patch error I am getting
>>>
>>> WARNING: please write a paragraph that describes the config symbol fully
>>> #108: FILE: arch/arm/plat-omap/Kconfig:41:
>>>         help
>>
>>> total: 0 errors, 1 warnings, 67 lines checked
>>
>>Yes that is a falsie.  I think I have fixed it in my tree.  Could you
>>test the version at the URL below and let me know if it works for you.
>>
>>  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

Yep this works. It no longer gives me the warning.
Thanks.

Regards
Thara
