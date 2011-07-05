Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1GEAY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 20:24:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:53292 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1GEAY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 20:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,476,1304319600"; 
   d="scan'208";a="22621558"
Message-ID: <4E1259D6.5050405@intel.com>
Date: Tue, 05 Jul 2011 08:24:54 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110606 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH -v2 3/4] ACPI, APEI, Add APEI bit support in generic _OSC
 call
References: <1309163160-3201-1-git-send-email-ying.huang@intel.com> <1309163160-3201-4-git-send-email-ying.huang@intel.com> <201107041228.51671.trenn@suse.de>
In-Reply-To: <201107041228.51671.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-6
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas,

On 07/04/2011 06:28 PM, Thomas Renninger wrote:
> On Monday, June 27, 2011 10:25:59 AM Huang Ying wrote:
> 
>>  extern bool osc_sb_apei_support_acked;
>>  
>> +extern bool osc_sb_apei_support_acked;
>> +
> double osc_sb_apei_support_acked declaration?

Sorry, I have some issue with patch management.  Will fix it in the new
version.

Best Regards,
Huang Ying
