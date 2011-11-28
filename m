Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1K1OCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:02:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:26801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab1K1OCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:02:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79785159"
Message-ID: <4ED39473.9080600@linux.intel.com>
Date: Mon, 28 Nov 2011 06:02:27 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        asharma@fb.com, devel@openvz.org, dsahern@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 7/7] event: add tracepoint for accounting block time
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>  <1322471015-107825-8-git-send-email-avagin@openvz.org> <1322480531.2921.107.camel@twins>
In-Reply-To: <1322480531.2921.107.camel@twins>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 3:42 AM, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 12:03 +0300, Andrew Vagin wrote:
>> This tracepoint shows how long a task is sleeping in uninterruptible state.
>>
>> E.g.
>> It may show how long and where a mutex is waited.
> 
> Fair enough, makes one wonder how much it would take to make
> account_scheduler_latency() go away..

I would *love* to switch latencytop to using trace points / perf events.
But as long as this just means I get yelled at more for using "internal
ABIs" and the like at various occasions, I'm rather hesitant to turn
more tools into using perf.

(and we all know what the next steps to resolve this are, they just have
not happened yet; not all hope is lost)
