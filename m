Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0CXIkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab0CXIkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:40:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100323144839.GA10424@redhat.com>
References: <20100323144839.GA10424@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] proc_sched_show_task: use get_nr_threads()
Date: Wed, 24 Mar 2010 08:40:13 +0000
Message-ID: <11646.1269420013@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Trivial, use get_nr_threads() helper to read signal->count which
> we are going to change.
> 
> Like other callers, proc_sched_show_task() doesn't need the exactly
> precise nr_threads.

Note that get_nr_threads() isn't completely equivalent (it can return 0 where
proc_sched_show_task() will display a 1).  But I don't think this should be a
problem.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
