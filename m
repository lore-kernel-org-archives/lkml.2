Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724Ab1FAUKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:10:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1FAUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:10:09 -0400
Date: Wed, 1 Jun 2011 22:08:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110601200807.GB9981@redhat.com>
References: <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org> <20110525182919.GB16575@redhat.com> <20110526091401.GD9715@htj.dyndns.org> <20110526150150.GD12525@redhat.com> <20110527182121.GA3212@mtj.dyndns.org> <20110530192255.GB20616@redhat.com> <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com> <20110531190809.GA20691@redhat.com> <20110601053408.GD23067@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601053408.GD23067@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Tue, May 31, 2011 at 09:08:09PM +0200, Oleg Nesterov wrote:
> > Speaking of this particular problem, it is really annoying. The leader
> > exits, and it even notifies the tracer. For what? waitpid() returns 0
> > or hangs depending on WNOHANG, any ptrace() request fails with ESRCH.
>
> Hmm... can't we just allow PTRACE_DETACH after PTRACE_EVENT_EXIT is
> reported?

Confused. PTRACE_DETACH surely works if the tracee reports EVENT_EXIT...
Could you explain what you meant?

Oleg.

