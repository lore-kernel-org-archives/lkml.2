Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab2EaHg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:36:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:59972 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2EaHg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:36:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106183645"
From: "Iyer, Sundar" <sundar.iyer@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Monroy, German" <german.monroy@intel.com>
Subject: RE: [PATCH v1] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Topic: [PATCH v1] x86/irq: handle chained interrupts during IRQ
 migration
Thread-Index: AQHNPZ3ufcQvbJgJHk6Lm6nGErQvy5bjJy0AgABceMA=
Date: Thu, 31 May 2012 07:36:19 +0000
Message-ID: <2FABAEF0D3DCAF4F9C9628D6E2F968451CE18C@BGSMSX102.gar.corp.intel.com>
References: <1338298808-2265-1-git-send-email-sundar.iyer@intel.com>
 <alpine.LFD.2.02.1205310930030.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205310930030.3231@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Thursday, May 31, 2012 1:01 PM
>>
>> Handle this by introducing a irq_is_chained() check which is based on
>> the IRQ_NOREQUEST flag being set for such interrupts. fixup_irq() can
>> then handle such interrupts and not skip them over.
>
>No, we need a separate flag for those. IRQ_NORREQUEST is not a reliable indicator.

I posted a v2 for this patch with all the flags; else will it be okay me adding
a new flag called IRQ_CHAINED and a new function similar to set_noprobe* helpers?

Cheers!
