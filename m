Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2DPQmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:42:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:43826 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab2DPQmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:42:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89624063"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 1/1] lpc_sch: Add Intel Centerton Multifunction Device
 support
Thread-Topic: [PATCH 1/1] lpc_sch: Add Intel Centerton Multifunction Device
 support
Thread-Index: AQHNB4R2CB+pEcOaUEqQ2EYPWLle1ZaeQCQA//+QHXA=
Date: Mon, 16 Apr 2012 16:42:41 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A41A52DBD@ORSMSX101.amr.corp.intel.com>
References: <1332349191-8068-1-git-send-email-seth.heasley@intel.com>
 <20120416162102.GM24130@sortiz-mobl>
In-Reply-To: <20120416162102.GM24130@sortiz-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

>>
>> +#define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
>> +
>So we're not going to need this ID anywhere else ? In the GPIO driver
>for example ?
>If we do need it there, this ID should move to pci_ids.h

Actually, it looks like the GPIO driver *will* need it, so I'll go ahead and move it to pci_ids.h since it's used in more than one driver.

>>  static struct resource smbus_sch_resource = {
>>  		.flags = IORESOURCE_IO,
>>  };
>> @@ -68,7 +71,7 @@ static struct resource wdt_sch_resource = {
>>
>>  static struct mfd_cell tunnelcreek_cells[] = {
>>  	{
>> -		.name = "tunnelcreek_wdt",
>> +		.name = "ie6xx_wdt",
>What do we need this change for ?

As mentioned in a previous email, the wdt driver is being renamed, so I'm reflecting that here.

I'll make a couple of changes and resubmit.

Regards,
-Seth
