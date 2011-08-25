Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1HYWtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:49:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41089 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1HYWtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:49:04 -0400
Date: Fri, 26 Aug 2011 00:48:59 +0200
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate
 subsys methods, take#2
Message-ID: <20110825224859.GU2803@mtj.dyndns.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314312192-26885-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 12:43:06AM +0200, Tejun Heo wrote:
> and is based on the current linux-pm/pm-freezer (7b5b95b3f5 "freezer:
> remove should_send_signal() and update frozen()"), and available in
> the following git tree.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer

Oops, that should have been

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cgroup_taskset

The above hasn't been properly mirrored yet (it should soon).  The
commit ID should be 53fd922e120c4ba0b65e388c2cda3c858f92db7c.
master.korg contains the master copy.

 ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cgroup_taskset

Thanks.

-- 
tejun
