Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1KUWH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:07:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47855 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1KUWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:07:25 -0500
Date: Mon, 21 Nov 2011 14:07:19 -0800
From: Tejun Heo <tj@kernel.org>
To: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCHSET] cgroup: stable threadgroup during attach & subsys
 methods consolidation
Message-ID: <20111121220719.GP25776@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320191193-8110-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:46:23PM -0700, Tejun Heo wrote:
> This patchset is combination of the following two patchsets.
> 
>  [1] cgroup: extend threadgroup locking
>  [2] cgroup: introduce cgroup_taskset and consolidate subsys methods, take#2

Li, do you agree with the proposed patches?  If so, I'll wait for
Frederic's response, repost updated series and merge it into the
cgroup tree.

Thank you.

-- 
tejun
