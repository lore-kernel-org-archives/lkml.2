Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1KCRQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:16:44 -0400
Received: from bender.cm4all.net ([87.106.27.49]:41199 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1KCRQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:16:43 -0400
Date: Thu, 3 Nov 2011 18:16:45 +0100
From: Max Kellermann <mk@cm4all.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tim Hockin <thockin@hockin.org>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103171645.GA27887@rabbit.intern.cm-ag>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
 <20111103164302.GE8198@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103164302.GE8198@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/03 17:43, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Please have a look at the task counter subsystem: https://lwn.net/Articles/461462/
> 
> It's in the -mm tree. I'm glad to hear about another user who wants
> this feature in cgroups. We need to hear about you and whether this
> meets your requirements in order to get it merged upstream.

Had a quick look at your patch set.  No, it does not seem to meet my
requirements.  It limits the number of processes in a cgroup - that is
also very useful, but is different from my controller.

My controller limits the number of fork() calls, not the number of
processes running at a time.

I've been using it for 7 years to put an upper bound on CGI resource
usage in a shared hosting environment at my employer (initially based
on a proprietary cgroup-like subsystem I wrote, when cgroups were not
available yet).

Max
