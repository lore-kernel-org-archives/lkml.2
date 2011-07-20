Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1GTTnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:43:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34532 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1GTTng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:43:36 -0400
Date: Wed, 20 Jul 2011 21:42:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Waychison <mikew@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Message-ID: <20110720194239.GC7910@elte.hu>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com>
 <20110714153113.31ffdeea.akpm@linux-foundation.org>
 <4E1F6F32.7040504@zytor.com>
 <CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGTjWtCL-4kqHdQsKHTwCC58y9nqHsJXqxpyygRi3qFvUsqVWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Waychison <mikew@google.com> wrote:

> On Thu, Jul 14, 2011 at 3:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 07/14/2011 03:31 PM, Andrew Morton wrote:
> >>
> >> sys_iopl() is missing asmlinkage.
> >>
> >> It would be far more conventional to use cond_syscall().  Perhaps by
> >> adding a CONFIG_X86 area into kernel/sys_ni.c
> >>
> >> fyi, I'm offering special deals on checkpatch.pl site licenses this month.
> >
> > Again, I don't think this makes sense as a compile-time-only option.
> 
> echo "enabled" > /proc/sys/kernel/iopl_available
> echo "disabled" > /proc/sys/kernel/iopl_available
> echo "locked" > /proc/sys/kernel/iopl_available

1, 0 and -1 ought to be a rather straightforward mapping to 'on', 
'off' and 'off forever'.

Thanks,

	Ingo
