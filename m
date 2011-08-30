Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1H3WsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:48:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:1993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1H3Wr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="43553833"
Message-ID: <4E5D6893.5010505@linux.intel.com>
Date: Tue, 30 Aug 2011 15:47:47 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>	<1314661157-22173-2-git-send-email-andi@firstfloor.org>	<20110830144407.acdae071.akpm@linux-foundation.org>	<4E5D5EE6.3070708@linux.intel.com> <20110830152216.dffd3cc3.akpm@linux-foundation.org>
In-Reply-To: <20110830152216.dffd3cc3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, deployment for new rlimits is a big PITA.  It would be sensible to
> modify the shells to take some anonymous numeric argument, so you could
> do
>
> 	ulimit 42 1000
>
> to set rlimit number 42 if your shell version doesn't understand the
> symbolic representation of more recent additions.  Who do I call?

I guess sending a patch to the bash maintainers?

-Andi

