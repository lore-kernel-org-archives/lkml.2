Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2KMV4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:56:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:26369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2KMV4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:56:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="219201013"
Message-ID: <50A2C21D.6070108@linux.intel.com>
Date: Tue, 13 Nov 2012 13:56:45 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com> <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com> <20121113211602.GA30150@linux.vnet.ibm.com>
In-Reply-To: <20121113211602.GA30150@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 1:16 PM, Paul E. McKenney wrote:
> On Mon, Nov 12, 2012 at 02:03:51PM -0800, Jacob Pan wrote:
>> Intel PowerClamp driver performs synchronized idle injection across
>> all online CPUs. The goal is to maintain a given package level C-state
>> ratio.
>>
>> Compared to other throttling methods already exist in the kernel,
>> such as ACPI PAD (taking CPUs offline) and clock modulation, this is often
>> more efficient in terms of performance per watt.
>>
>> Please refer to Documentation/thermal/intel_powerclamp.txt for more details.
> 
> If I read this correctly, this forces a group of CPUs into idle for
> about 600 milliseconds at a time.  This would indeed delay grace periods,

6ms not 600


