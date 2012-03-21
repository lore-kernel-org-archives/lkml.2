Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2CUFIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:08:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49958 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2CUFIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:08:50 -0400
MIME-Version: 1.0
In-Reply-To: <4F695C3F.3000406@jp.fujitsu.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
	<1331940963-15756-7-git-send-email-tj@kernel.org>
	<4F66B55A.8020307@jp.fujitsu.com>
	<20120319161052.GC11069@google.com>
	<4F695C3F.3000406@jp.fujitsu.com>
Date: Tue, 20 Mar 2012 22:08:49 -0700
X-Google-Sender-Auth: 7H7z3O6njgwiXtU4mA9yz35zwuc
Message-ID: <CAOS58YOwtmOG5tDuMtFCw=sHV-aeU-Ok+KXzR81Aix+OZqMpUA@mail.gmail.com>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new cftype interface
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 20, 2012 at 9:42 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I think creating file based on really_do_swap_account is wrong.
> (I'm sorry for this complication.)
>
> How about creating this file unconditionally ? Returning -ENOTSUP in memcg's
> handler will work well...anyway it's configured, no reason to show them is bad.

That works for me. Then, I can also remove the _COND thing which isn't
pretty anyway. I'll update the patchset.

Thanks.

-- 
tejun
