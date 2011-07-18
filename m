Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1GROfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:35:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1GROfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:35:20 -0400
Date: Mon, 18 Jul 2011 16:35:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
In-Reply-To: <4E1F5429.6080903@zytor.com>
Message-ID: <alpine.LRH.2.00.1107181634271.11861@twin.jikos.cz>
References: <1310675693-9204-1-git-send-email-mikew@google.com> <1310675693-9204-2-git-send-email-mikew@google.com> <4E1F5380.9020709@zytor.com> <CAGTjWtD8Obn0LsXr+Dq7xqQEYnY4UV7CAiO2+L2LLpv_1s_ufw@mail.gmail.com> <4E1F5429.6080903@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, H. Peter Anvin wrote:

> >> Wouldn't it be more useful for this to be a sysctl?  In particular, like
> >> many similar things it probably should be a lockable sysctl (three
> >> states: enabled, disabled, and locked-disabled).
> >>
> >> Making it a compile-time option I'm very skeptical to.
> > 
> > Are there existing examples of this already in the tree?
> 
> I think so, but I don't know off the top of my head.

/proc/sys/kernel/modules_disabled is a sort-of that kind of thing (it 
doesn't have three states, but only two -- enabled and locked-disabled).

-- 
Jiri Kosina
SUSE Labs

