Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1DDQVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:21:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1DDQVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:21:19 -0400
Date: Mon, 4 Apr 2011 18:20:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110404162041.GA24086@redhat.com>
References: <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com> <1301496684.4859.192.camel@twins> <20110331132815.GA4267@redhat.com> <1301579484.4859.277.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301579484.4859.277.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Peter Zijlstra wrote:
>
> Anyway, I _think_ we can do better.. but then, I haven't fully gone
> through things yet.. compile tested only..

I'll try to read (and hopefully even understand ;) this patch carefully,
but at first glance this should work.

Personally, as a _reader_ of this code, I like the fact that
perf_event_release_kernel() does perf_remove_from_context() instead of
_disable + del_event. IMHO, this makes the things more understandable.

Oleg.

