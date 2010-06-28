Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0F1IjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 04:39:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:44338 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab0F1IjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 04:39:05 -0400
Message-ID: <4C285F8F.3040707@kernel.org>
Date: Mon, 28 Jun 2010 10:38:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: simplify the usage of percpu data
References: <4C285C60.90801@cn.fujitsu.com>
In-Reply-To: <4C285C60.90801@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 08:38:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 10:25 AM, Lai Jiangshan wrote:
> &percpu_data is compatible with allocated percpu data.
> 
> And we use it and remove the "rda[NR_CPUS]" array.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Looks good to me.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
