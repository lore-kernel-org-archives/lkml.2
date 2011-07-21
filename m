Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1GUCyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 22:54:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:44702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1GUCyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 22:54:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,238,1309762800"; 
   d="scan'208";a="28351518"
Message-ID: <4E2794D5.1030104@intel.com>
Date: Thu, 21 Jul 2011 10:54:13 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com> <20110721024204.GJ8006@one.firstfloor.org>
In-Reply-To: <20110721024204.GJ8006@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 10:42 AM, Andi Kleen wrote:
>>  
>> +static bool param_extension;
>> +module_param(param_extension, bool, 0);
> 
> Make it 0644, then it can be changed at runtime. No need to require a reboot.

Normally, EINJ is compiled as module, so we can change it at load time
without a reboot.

Do we need the real runtime switching capability?

Best Regards,
Huang Ying
