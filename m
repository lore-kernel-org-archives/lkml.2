Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0EGFZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:25:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0EGFZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:25:50 -0400
Message-ID: <4BE3A421.9000009@kernel.org>
Date: Fri, 07 May 2010 07:24:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/5] sched: replace migration_thread with cpu_stop
References: <1273164772-19149-1-git-send-email-tj@kernel.org> <1273164772-19149-4-git-send-email-tj@kernel.org> <20100506192904.GD2325@linux.vnet.ibm.com>
In-Reply-To: <20100506192904.GD2325@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 05:24:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 09:29 PM, Paul E. McKenney wrote:
> With the two patches submitted:
> 
> Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Paul's second fix (adding barrier() to UP variant) is added to the
branch.

Thanks.

-- 
tejun
