Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1KNSww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:52:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48961 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1KNSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:52:50 -0500
Date: Mon, 14 Nov 2011 19:52:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 04/10] cgroup: always lock threadgroup during migration
Message-ID: <20111114185242.GF9446@somewhere>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-5-git-send-email-tj@kernel.org>
 <20111114184630.GE9446@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114184630.GE9446@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 07:46:34PM +0100, Frederic Weisbecker wrote:
> I have the feeling the task_lock is now useless given that we are synchronized
> against cgroup_exit() with the threadgroup_lock.
> 
> It's probably also useless in cgroup_exit(). But that's something for a further
> patch...
> 
> Thanks.

Oops, I missed what Kamezawa said and your answer, sorry.
