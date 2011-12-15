Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1LOFtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:49:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab1LOFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:49:01 -0500
Date: Thu, 15 Dec 2011 00:48:36 -0500 (EST)
Message-Id: <20111215.004836.402973956281143052.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org, paul@paulmenage.org,
        lizf@cn.fujitsu.com, ebiederm@xmission.com, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com, devel@openvz.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/9] Request for inclusion: per-cgroup tcp memory
 pressure controls
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111215144019.03706ff7.kamezawa.hiroyu@jp.fujitsu.com>
References: <1323676029-5890-1-git-send-email-glommer@parallels.com>
	<20111215144019.03706ff7.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 14 Dec 2011 21:48:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 15 Dec 2011 14:40:19 +0900

> I met this bug at _1st_ run. Please enable _all_ debug options!.

Plus the CONFIG_NET=n and other build failures.

This patch series was seriously rushed, and very poorly handled.

Yet I kept getting so much pressure to review, comment upon, and
ultimately apply these patches.  Never, ever, do this to me ever
again.

If I don't feel your patches are high priority enough or ready enough
for me to review, then TOO BAD.  Don't ask people to pressure me or
get my attention.  Instead, ask others for help and do testing before
wasting MY time and crapping up MY tree.

I should have noticed a red flag when I have James Bottomly asking me
to look at these patches, I should have pushed back.  Instead, I
relented, and now I'm very seriously regretting it.

All the regressions in the net-next tree over the past several days
have been due to this patch set, and this patch set alone.

This code wasn't ready and needed, at a minimum, several more weeks of
work before being put in.

Instead, we're going to bandaid patch it up after the fact, rather
than just letting these changes mature naturally during the review
process.
