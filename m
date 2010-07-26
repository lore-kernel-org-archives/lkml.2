Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0GZHNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:13:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:40720 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0GZHNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:13:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,260,1278313200"; 
   d="scan'208";a="304271038"
Message-ID: <4C4D358D.8070709@linux.intel.com>
Date: Mon, 26 Jul 2010 09:13:17 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fix apei related table size checking
References: <4C49D3C5.4000007@kernel.org> <201007252223.32671.bjorn.helgaas@hp.com>
In-Reply-To: <201007252223.32671.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 7/26/2010 6:23 AM, Bjorn Helgaas wrote:
> On Friday, July 23, 2010 11:39:17 am Yinghai Lu wrote:
>> also check if we can find right action in apei.
>>
>> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> This should be split into two patches that each fix one thing.

... and the description actually describe what it is supposed to fix.

-Andi

