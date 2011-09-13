Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1IMRfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:35:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56445 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1IMRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:35:38 -0400
Date: Tue, 13 Sep 2011 19:35:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/12] cgroups: Add documentation for task counter
 subsystem
Message-ID: <20110913173528.GE23424@somewhere>
References: <1315267986-28937-1-git-send-email-fweisbec@gmail.com>
 <1315267986-28937-11-git-send-email-fweisbec@gmail.com>
 <20110906154131.3340842e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906154131.3340842e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 03:41:31PM -0700, Andrew Morton wrote:
> Oh.  And I now see that the documentation file provides no documentation
> for the code in cgroup_task_counter.c anyway.  Really?

I've added more comment in that file for the v5. Especially for
the can_attach - attach - cancel_attach sequence that is a bit
tricky.

Thanks.
