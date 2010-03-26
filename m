Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0CZMXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab0CZMXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:23:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2375c9f91003251943r4663ae51r5791acc374b6ccc4@mail.gmail.com>
References: <2375c9f91003251943r4663ae51r5791acc374b6ccc4@mail.gmail.com> <1264740107.20211.53.camel@pasglop> <6397.1269516539@redhat.com>
To: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FAm=3DC3=3DA9rico=5FWang=3F=3D?= 
	<xiyou.wangcong@gmail.com>,
       torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Mar 2010 12:22:02 +0000
Message-ID: <6253.1269606122@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> wrote:

> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.34-rc2-cachefs #115
> > -------------------------------------------------------
> > halt/2291 is trying to acquire lock:
> >  (s_active#31){++++.+}, at: [<ffffffff81104950>] sysfs_addrm_finish+0x31/0x5a
> >
> > but task is already holding lock:
> >  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff812a3a92>] lock_policy_rwsem_write+0x4a/0x7b
> >
> > which lock already depends on the new lock.
> >
> 
> 
> I already send a patch for this:
> 
> https://patchwork.kernel.org/patch/83558/
> 
> It is still in -mm tree, I think.

Tested-by: David Howells <dhowells@redhat.com>
