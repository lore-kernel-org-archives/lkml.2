Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1FXUYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 16:24:03 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53341 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab1FXUYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 16:24:00 -0400
Date: Fri, 24 Jun 2011 13:20:15 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        djm@mindrot.org, segoon@openwall.com, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, fweisbec@gmail.com,
        tglx@linutronix.de, scarybeasts@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Mike Galbraith <efault@gmx.de>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 03/13] seccomp_filter: new mode with configurable
 syscall filters
Message-ID: <20110624202015.GD32221@outflux.net>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
 <1308875813-20122-3-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308875813-20122-3-git-send-email-wad@chromium.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Thu, Jun 23, 2011 at 07:36:42PM -0500, Will Drewry wrote:
> This change adds a new seccomp mode which specifies the allowed system
> calls dynamically.  When in the new mode (2), all system calls are
> checked against process-defined filters - first by system call number,
> then by a filter string.  If an entry exists for a given system call and
> all filter predicates evaluate to true, then the task may proceed.
> Otherwise, the task is killed.
> [...]
> Signed-off-by: Will Drewry <wad@chromium.org>

Thanks for continuing to work on this. I look forward to being able to use
it. :)

Acked-by: Kees Cook <kees.cook@canonical.com>

-- 
Kees Cook
Ubuntu Security Team
