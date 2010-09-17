Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0IQNlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:41:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:44939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0IQNle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:41:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,382,1280732400"; 
   d="scan'208";a="555449323"
Message-ID: <4C936FFF.5030303@linux.intel.com>
Date: Fri, 17 Sep 2010 15:41:19 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Conny Seidel <conny.seidel@amd.com>
CC: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "borislav.petkov@" <amd.com.borislav.petkov@amd.com>
Subject: Re: 7ad6e9435596f692ff65f399da12816c94960185 breaks AMD f10h.
References: <20100917145625.75d2a412@marah.osrc.amd.com>
In-Reply-To: <20100917145625.75d2a412@marah.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/17/2010 2:56 PM, Conny Seidel wrote:
> Hi,
>
> Kernel v2.6.36-rc4-134-g03a7ab0 breaks with the OOPS below.
>
> Reverting the commitid in the subject fixes the issue.
> This is because APEI is selected by default on X86 (X86&&  ACPI),
> maybe a vendor check in the hest_init() might make sense.

It looks like your system has a duplicated hest source ID. They are supposed
to have unique identifiers.

The kernel should not oops of course, but it's really a BIOS bug imho.

-Andi

