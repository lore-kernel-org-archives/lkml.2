Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0IVSN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:13:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:60131 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0IVSNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:13:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,219,1283756400"; 
   d="scan'208";a="609383455"
Message-ID: <4C9A473F.1060301@linux.intel.com>
Date: Wed, 22 Sep 2010 11:13:19 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-pm@lists.linux-foundation.org,
        Jean Pihet <jean.pihet@newoldbits.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com> <4C9A21AD.1000800@linux.intel.com> <201009221957.57845.trenn@suse.de>
In-Reply-To: <201009221957.57845.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/22/2010 10:57 AM, Thomas Renninger wrote:
> On Wed
>> unfortunately this code is changing a userspace ABI... we really
>> shouldn't do that if we can avoid it,
>> and here we can avoid it.

[do you really need to get personal?]

> Wow, this is your first post on this thread

it isn't.

(but I've been traveling too much in the last few weeks and have been 
rather overwhelmed in mail as a result)

