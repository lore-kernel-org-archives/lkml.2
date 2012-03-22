Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2CVA30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:29:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44052 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2CVA3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:29:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6A71F8.1060808@jp.fujitsu.com>
Date: Thu, 22 Mar 2012 09:27:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 08/12] cgroup: convert memcg controller to the new cftype
 interface
References: <1332368265-21586-1-git-send-email-tj@kernel.org> <1332368265-21586-9-git-send-email-tj@kernel.org>
In-Reply-To: <1332368265-21586-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/22 7:17), Tejun Heo wrote:

> Convert memcg to use the new cftype based interface.  kmem support
> abuses ->populate() for mem_cgroup_sockets_init() so it can't be
> removed at the moment.
> 
> tcp_memcontrol is updated so that tcp_files[] is registered via a
> __initcall.  This change also allows removing the forward declaration
> of tcp_files[].  Removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Greg Thelen <gthelen@google.com>


Ok, then, files will be created by cgroup core not by memcg.
base_cftypes seems very good.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you.

