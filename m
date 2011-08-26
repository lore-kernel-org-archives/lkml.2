Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab1HZEXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 00:23:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37155 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1HZEXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 00:23:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Aug 2011 13:16:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/6] cgroup: introduce cgroup_taskset and use it in
 subsys->can_attach(), cancel_attach() and attach()
Message-Id: <20110826131614.bf9b73c6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1314312192-26885-4-git-send-email-tj@kernel.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
	<1314312192-26885-4-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 00:43:09 +0200
Tejun Heo <tj@kernel.org> wrote:

> Currently, there's no way to pass multiple tasks to cgroup_subsys
> methods necessitating the need for separate per-process and per-task
> methods.  This patch introduces cgroup_taskset which can be used to
> pass multiple tasks and their associated cgroups to cgroup_subsys
> methods.
> 
> Three methods - can_attach(), cancel_attach() and attach() - are
> converted to use cgroup_taskset.  This unifies passed parameters so
> that all methods have access to all information.  Conversions in this
> patchset are identical and don't introduce any behavior change.
> 
> -v2: documentation updated as per Paul Menage's suggestion.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: James Morris <jmorris@namei.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

