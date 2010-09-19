Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0ISPIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:08:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:52938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0ISPIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:08:30 -0400
Message-ID: <4C9627B6.6030300@kernel.org>
Date: Sun, 19 Sep 2010 17:09:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 1/6] percpu: {get,put}_cpu_ptr
References: <20100917092844.651383640@chello.nl> <20100917093009.252867712@chello.nl>
In-Reply-To: <20100917093009.252867712@chello.nl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 19 Sep 2010 15:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 11:28 AM, Peter Zijlstra wrote:
> Similar to {get,put}_cpu_var() except for dynamically allocated per-cpu memory.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Tejun Heo <tj@kernel.org>

How do you want to route this?  Given that perf is the only user at
this point, feel free to push this with other perf changes.

Thanks.

-- 
tejun
