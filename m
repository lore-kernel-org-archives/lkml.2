Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1KUWF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:05:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54238 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab1KUWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:05:26 -0500
Date: Mon, 21 Nov 2011 14:05:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 04/10] cgroup: always lock threadgroup during migration
Message-ID: <20111121220519.GO25776@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-5-git-send-email-tj@kernel.org>
 <20111114184630.GE9446@somewhere>
 <20111114185242.GF9446@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114185242.GF9446@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 07:52:43PM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 14, 2011 at 07:46:34PM +0100, Frederic Weisbecker wrote:
> > I have the feeling the task_lock is now useless given that we are synchronized
> > against cgroup_exit() with the threadgroup_lock.
> > 
> > It's probably also useless in cgroup_exit(). But that's something for a further
> > patch...
> > 
> > Thanks.
> 
> Oops, I missed what Kamezawa said and your answer, sorry.

Yeap, I'll see how removing it for put looks.

Thanks.

-- 
tejun
