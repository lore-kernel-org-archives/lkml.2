Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0D1UX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:23:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:45636 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0D1UX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:23:57 -0400
Message-ID: <4BD89922.1040306@kernel.org>
Date: Wed, 28 Apr 2010 22:22:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
References: <1272429119-12103-1-git-send-email-arve@android.com> <1272429119-12103-2-git-send-email-arve@android.com> <1272429119-12103-3-git-send-email-arve@android.com> <1272429119-12103-4-git-send-email-arve@android.com> <1272429119-12103-5-git-send-email-arve@android.com> <1272429119-12103-6-git-send-email-arve@android.com> <1272429119-12103-7-git-send-email-arve@android.com> <20100428194028.GA16389@redhat.com>
In-Reply-To: <20100428194028.GA16389@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 20:23:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 09:40 PM, Oleg Nesterov wrote:
>> +int schedule_suspend_blocking_work(struct suspend_blocking_work *work)
>> +{
>> ...
>> +	ret = schedule_work(&work->work);
> 
> Off-topic. We should probably export keventd_wq to avoid the duplications
> like this.

Yeah, had about the same thought.  cmwq exports it so I didn't suggest
it at this point but then again we don't really know whether or when
that series is going in so it might be a good idea to make that change
now.  Hmm...

Thanks.

-- 
tejun
