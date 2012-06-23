Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2FWHbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 03:31:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:41556 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab2FWHbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 03:31:09 -0400
Date: Sat, 23 Jun 2012 17:30:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
In-Reply-To: <CAGXu5j+jhitULgFd_9VmRgcShVa9d+6pqT2hyDu7LEmc_BHDew@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1206231729320.16738@tundra.namei.org>
References: <20120622192413.GA5774@www.outflux.net> <20120622125551.269552c2.akpm@linux-foundation.org> <CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com> <20120622143435.c1ba744e.akpm@linux-foundation.org>
 <CAGXu5jJq-hZ4Q-ThdQ+KD=uGgHq1KP0_tTsefG8qkFGi8Em-qw@mail.gmail.com> <20120622145711.d7f720cd.akpm@linux-foundation.org> <CAGXu5jLOJrZTNKh=G75wP2fo-cPj_mM-Urc+4hDVvyJpiy+7Dg@mail.gmail.com> <20120622152029.638ade70.akpm@linux-foundation.org>
 <CAGXu5j+jhitULgFd_9VmRgcShVa9d+6pqT2hyDu7LEmc_BHDew@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, Kees Cook wrote:

> Okay, sounds good. Should mode 3 added with mode 2 removed, or just
> drop the dangerous behavior from mode 2? I will be loud in either
> situation (e.g. with mode 3, setting mode 2 shouts, or when attempt to
> write to disk in mode 2, shout).

I'd prefer to drop the dangerous behavior.



-- 
James Morris
<jmorris@namei.org>
