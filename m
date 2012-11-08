Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab2KHEZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:25:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44933 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2KHEZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:25:53 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B343E.3050706@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 13:25:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 5/9] cgroup_freezer: prepare freezer_change_state() for
 full hierarchy support
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-6-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-6-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/03 17:38), Tejun Heo wrote:
> * Make freezer_change_state() take bool @freeze instead of enum
>    freezer_state.
>
> * Separate out freezer_apply_state() out of freezer_change_state().
>    This makes freezer_change_state() a rather silly thin wrapper.  It
>    will be filled with hierarchy handling later on.
>
> This patch doesn't introduce any behavior change.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


