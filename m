Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2DRQAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:00:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:10339 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2DRQAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:00:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="132448140"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Thread-Topic: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Thread-Index: AQHNHN7OVZLDEVRYmEOs38aIQI0D4Zag1K0A///ovoA=
Date: Wed, 18 Apr 2012 15:59:49 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A41A5CB9B@ORSMSX102.amr.corp.intel.com>
References: <1334696962-3642-1-git-send-email-seth.heasley@intel.com>
 <20120418101802.GD1204@sortiz-mobl>
In-Reply-To: <20120418101802.GD1204@sortiz-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

>Is the pci_ids.h change already in ? If not, I should take it at the
>same time so that we don't break compilation.

It was submitted just prior to my sending this patch.

>> @@ -68,7 +69,7 @@ static struct resource wdt_sch_resource = {
>>
>>  static struct mfd_cell tunnelcreek_cells[] = {
>>  	{
>> -		.name = "tunnelcreek_wdt",
>> +		.name = "ie6xx_wdt",
>>  		.num_resources = 1,
>>  		.resources = &wdt_sch_resource,
>>  	},
>This one should be part of your upcoming watchdog driver patch (as a
>separate patch that I'd take).

I'm actually not submitting a watchdog patch.  The maintainer already has code for this driver and is converting it to the new watchdog API.  In discussions with him, we agreed to the renaming of the driver, which was submitted for a previous platform.  He'll be committing the new code in the next couple of weeks, so I made this change in anticipation of the driver making it upstream.  I can certainly submit this separately, but my thinking was that it's all connected to Centerton enabling since it uses the same driver.  Let me know what you'd like me to do.

Regards,
-Seth
