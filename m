Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0HDPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0HDPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:47:17 -0400
Date: Wed, 4 Aug 2010 17:44:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner
	comment
Message-ID: <20100804154412.GA8822@redhat.com>
References: <20100804150805.GA5634@redhat.com> <20100804131749.GA2139@redhat.com> <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> <AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> <23577.1280930470@redhat.com> <25284.1280935357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25284.1280935357@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > > > I must admit, at first glance changing check_kill_permission() to take
> > > > rcu lock looks better to me.
> > >
> > > I think group_send_sig_info() would be better.  The only other caller of
> > > c_k_p() already has to hold the RCU read lock for other reasons.
> > >
> > > How about the attached patch then?
> >
> > Agreed, the patch looks fine to me.
>
> Can I take that as an Acked-by?

Yes, thanks, please feel free to add

Acked-by: Oleg Nesterov <oleg@redhat.com>

