Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1IMOxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:53:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:38168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1IMOxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:53:11 -0400
Subject: Re: [PATCH 00/11 v5] cgroups: Task counter subsystem
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, Containers <containers@lists.osdl.org>
Date: Tue, 13 Sep 2011 16:49:20 +0200
In-Reply-To: <20110913143749.GA23424@somewhere>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
	 <1315924371.5977.16.camel@twins> <20110913143749.GA23424@somewhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315925360.5977.17.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 16:37 +0200, Frederic Weisbecker wrote:
> Because cgroup_task_limit.c sounds way too much generic to be
> self-explanatory.

Uhm, why? That's exactly what it does, no? It limits the number of
tasks.
