Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249Ab2CVAY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:24:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33535 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2CVAYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:24:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6A70EE.3050107@jp.fujitsu.com>
Date: Thu, 22 Mar 2012 09:23:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Subject: Re: [PATCH 07/12] memcg: always create memsw files if CONFIG_CGROUP_MEM_RES_CTLR_SWAP
References: <1332368265-21586-1-git-send-email-tj@kernel.org> <1332368265-21586-8-git-send-email-tj@kernel.org>
In-Reply-To: <1332368265-21586-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/22 7:17), Tejun Heo wrote:

> Instead of conditioning creation of memsw files on do_swap_account,
> always create the files if compiled-in and fail read/write attempts
> with -EOPNOTSUPP if !do_swap_account.
> 
> This is suggested by KAMEZAWA to simplify memcg file creation so that
> it can use cgroup->subsys_cftypes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


seems O.K. to me.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

