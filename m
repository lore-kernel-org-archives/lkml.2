Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1IVRf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:35:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:26063 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1IVRf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="54035772"
Message-ID: <4E7B71DA.90909@linux.intel.com>
Date: Thu, 22 Sep 2011 10:35:22 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: khilman@ti.com, venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, santosh.shilimkar@ti.com, lenb@kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH V6 0/4] cpuidle: Global registration of idle states
 with per-cpu statistics
References: <20110922082840.10520.85895.stgit@localhost6.localdomain6>
In-Reply-To: <20110922082840.10520.85895.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/2011 1:28 AM, Deepthi Dharwar wrote:
> The following patch series implements global registration of cpuidle
> states, and also has the necessary data structure changes to
> accommodate the per-cpu writable members of the cpuidle_states
> structure.
>


you can consider this series Acked-by: Arjan van de Ven 
<arjan@linux.intel.com>
it's a good simplification of the code, and unlike frequencies, idle 
states are really shared between all cpus for
very practical reasons.

