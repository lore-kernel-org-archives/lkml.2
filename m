Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0EWJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:25:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:46462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0EWJZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:25:09 -0400
Message-ID: <4BF8F46A.1060407@kernel.org>
Date: Sun, 23 May 2010 11:24:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
References: <1273747705-7829-1-git-send-email-tj@kernel.org> <4BF1CD92.9030800@kernel.org> <4BF689DD.2090306@kernel.org> <20100523090544.GB25524@elte.hu> <4BF8F0A4.5060608@kernel.org> <20100523091306.GE25524@elte.hu>
In-Reply-To: <20100523091306.GE25524@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 May 2010 09:25:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/23/2010 11:13 AM, Ingo Molnar wrote:
> ... which is then used for the concurrency-managed 
> workqueue feature, which is then used for a BTRFS speedup, 
> right?
>
> ( If that's not the plan then color me confused :)

Yeap, you're officially confused. :-) It doesn't have much to do with
btrfs at this point and performance test result was posted earlier
this year (on your request too) where it performed quite similarly to
the workqueue code on the favorable side while providing much easier
API for its users.

The whole thing has been sitting in my queue for months now blocked on
these scheduler changes.  I've requested multiple times to push this
forward on at least a separate sched devel branch and make incremental
changes from there if scheduler side is not satisfactory so that the
whole code base can be tested in wider scope and fix and improvement
history can be kept in git, about which you always have had a pretty
strong opinion about.  There is no outstanding major opposition to
cmwq itself (fscache conversion needs more performance testing tho).
The whole thing is blocked on these scheduler changes.  What's up?

Thanks.

-- 
tejun
