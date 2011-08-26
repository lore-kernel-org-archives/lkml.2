Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1HZE0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 00:26:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45611 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1HZE0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 00:26:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Aug 2011 13:19:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com
Subject: Re: [PATCH 5/6] cgroup, cpuset: don't use ss->pre_attach()
Message-Id: <20110826131921.b643491a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1314312192-26885-6-git-send-email-tj@kernel.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
	<1314312192-26885-6-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 00:43:11 +0200
Tejun Heo <tj@kernel.org> wrote:

> ->pre_attach() is supposed to be called before migration, which is
> observed during process migration but task migration does it the other
> way around.  The only ->pre_attach() user is cpuset which can do the
> same operaitons in ->can_attach().  Collapse cpuset_pre_attach() into
> cpuset_can_attach().
> 
> -v2: Patch contamination from later patch removed.  Spotted by Paul
>      Menage.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

