Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab1FQBxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:53:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:7053 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab1FQBxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:53:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,378,1304319600"; 
   d="scan'208";a="14235859"
Message-ID: <4DFAB387.2010500@intel.com>
Date: Fri, 17 Jun 2011 09:53:11 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
References: <20110614145246.GA17469@srcf.ucam.org> <4DF82CBC.5070400@intel.com> <20110615121703.GA8638@srcf.ucam.org> <4DF950EB.7050400@intel.com> <20110616013812.GA32494@srcf.ucam.org> <4DF962AE.60204@intel.com> <20110616015736.GA32533@srcf.ucam.org> <4DFAA665.8070305@intel.com> <20110617013442.GA30708@srcf.ucam.org> <4DFAB081.6050800@intel.com> <20110617014213.GA30826@srcf.ucam.org>
In-Reply-To: <20110617014213.GA30826@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 09:42 AM, Matthew Garrett wrote:
> On Fri, Jun 17, 2011 at 09:40:17AM +0800, Huang Ying wrote:
>> On 06/17/2011 09:34 AM, Matthew Garrett wrote:
>>> If the kernel has been configured with support for the feature then I 
>>> think we ought to be able to assume that the kernel will support it at 
>>> runtime.
>>
>> There may be error during driver initialization.  That is what I am
>> concerned.
> 
> That's true of any _OSC functionality.

I see.  This should be fixed in the long run.  So I will add "APEI bit"
support if GHES is configured.

Best Regards,
Huang Ying
