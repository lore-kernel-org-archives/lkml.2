Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2KGNGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:06:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:8229 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab2KGNGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:06:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="216294149"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Shuah Khan <shuahkhan@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNvEyBXY6qKU083U+UjDldvhm0q5feV85A
Date: Wed, 7 Nov 2012 13:06:46 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537B9E9@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <CAKocOONye3HDcuxOyOLqD=Z=EkESzQb0FNanbUJeyLJJVCDWdw@mail.gmail.com>
In-Reply-To: <CAKocOONye3HDcuxOyOLqD=Z=EkESzQb0FNanbUJeyLJJVCDWdw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan wrote:
> On Thu, Oct 25, 2012 at 6:19 AM, Liu, Jinsong <jinsong.liu@intel.com>
> wrote: 
>> From f233ad06cf924116693d7d38be9ae9d8c11f8a9b Mon Sep 17 00:00:00
>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Fri, 26 Oct 2012 02:32:48 +0800
>> Subject: [PATCH 1/2] Xen acpi pad implement
>> 
>> PAD is acpi Processor Aggregator Device which provides a control
>> point 
>> that enables the platform to perform specific processor configuration
>> and control that applies to all processors in the platform.
>> 
>> This patch is to implement Xen acpi pad logic. When running under Xen
>> virt platform, native pad driver would not work. Instead Xen pad
>> driver, 
>> a self-contained and very thin logic level, would take over acpi pad
>> staff. 
> 
> "logic" instead of staff (guessing this is supposed to stuff)
> 

Yes.

>> When acpi pad notify OSPM, xen pad logic intercept and parse _PUR
>> object 
>> and then hypercall to hyervisor for the rest work, say, core parking.
> hypervisor
> rest of the work? - could you add more details on what is handled by
> this think PAD driver and what would be left to the host pad driver.

OK, add at updated patch.

Thanks,
Jinsong