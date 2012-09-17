Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2IQN7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab2IQN7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:59:51 -0400
Message-ID: <50572CD1.700@redhat.com>
Date: Mon, 17 Sep 2012 09:59:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Youquan Song <youquan.song@intel.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        arjan@linux.intel.com, lenb@kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH V2 1/3] x86,idle: Quickly notice prediction failure for
 repeat mode
References: <1347933209-25939-1-git-send-email-youquan.song@intel.com> <1347933209-25939-2-git-send-email-youquan.song@intel.com>
In-Reply-To: <1347933209-25939-2-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 09:53 PM, Youquan Song wrote:
> The prediction for future is difficult and when the cpuidle governor prediction
> fails and govenor possibly choose the shallower C-state than it should. How to
> quickly notice and find the failure becomes important for power saving.
>
> cpuidle menu governor has a method to predict the repeat pattern if there are 8
> C-states residency which are continuous and the same or very close, so it will
> predict the next C-states residency will keep same residency time.

Could I convince you to try out my variation on
detect_repeating_intervals? :)

http://people.redhat.com/riel/cstate/cstate-stddev-converge.patch

I suspect that small change might help your code adapt to changed
conditions even faster.

-- 
All rights reversed
