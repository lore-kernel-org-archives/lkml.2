Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab1HZET5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 00:19:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42577 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1HZET4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 00:19:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Aug 2011 13:12:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com
Subject: Re: [PATCH 1/6] cgroup: subsys->attach_task() should be called
 after migration
Message-Id: <20110826131226.916f08da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1314312192-26885-2-git-send-email-tj@kernel.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
	<1314312192-26885-2-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 00:43:07 +0200
Tejun Heo <tj@kernel.org> wrote:

> cgroup_attach_task() calls subsys->attach_task() after
> cgroup_task_migrate(); however, cgroup_attach_proc() calls it before
> migration.  This actually affects some of the users.  Update
> cgroup_attach_proc() such that ->attach_task() is called after
> migration.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>'

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@Jp.fujitsu.com>

