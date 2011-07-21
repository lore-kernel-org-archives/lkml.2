Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab1GUE1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 00:27:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:8660 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab1GUE1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 00:27:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,239,1309762800"; 
   d="scan'208";a="29731461"
Message-ID: <4E27AA99.4000102@intel.com>
Date: Thu, 21 Jul 2011 12:27:05 +0800
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
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com> <20110721024204.GJ8006@one.firstfloor.org> <4E2794D5.1030104@intel.com> <20110721041610.GL8006@one.firstfloor.org>
In-Reply-To: <20110721041610.GL8006@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 12:16 PM, Andi Kleen wrote:
> On Thu, Jul 21, 2011 at 10:54:13AM +0800, Huang Ying wrote:
>> On 07/21/2011 10:42 AM, Andi Kleen wrote:
>>>>  
>>>> +static bool param_extension;
>>>> +module_param(param_extension, bool, 0);
>>>
>>> Make it 0644, then it can be changed at runtime. No need to require a reboot.
>>
>> Normally, EINJ is compiled as module, so we can change it at load time
>> without a reboot.
> 
> Ok. 
> 
>>
>> Do we need the real runtime switching capability?
> 
> I usually do that with modparams when it's possible. After all it's very
> simple and doesn't cost anything.

To avoid confuse user, the param1/param2 files are created only if
param_extension=y is specified.  So making modprams changeable in run
time may make situation a little complex.

Best Regards,
Huang Ying
