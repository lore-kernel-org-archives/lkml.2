Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0HDPXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0HDPX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:23:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100804150805.GA5634@redhat.com>
References: <20100804150805.GA5634@redhat.com> <20100804131749.GA2139@redhat.com> <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> <23577.1280930470@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner comment
Date: Wed, 04 Aug 2010 16:22:37 +0100
Message-ID: <25284.1280935357@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> > > I must admit, at first glance changing check_kill_permission() to take
> > > rcu lock looks better to me.
> >
> > I think group_send_sig_info() would be better.  The only other caller of
> > c_k_p() already has to hold the RCU read lock for other reasons.
> >
> > How about the attached patch then?
> 
> Agreed, the patch looks fine to me.

Can I take that as an Acked-by?

David
