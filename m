Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746Ab2FVV5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:57:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2FVV5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:57:13 -0400
Date: Fri, 22 Jun 2012 14:57:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
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
Message-Id: <20120622145711.d7f720cd.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jJq-hZ4Q-ThdQ+KD=uGgHq1KP0_tTsefG8qkFGi8Em-qw@mail.gmail.com>
References: <20120622192413.GA5774@www.outflux.net>
	<20120622125551.269552c2.akpm@linux-foundation.org>
	<CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com>
	<20120622143435.c1ba744e.akpm@linux-foundation.org>
	<CAGXu5jJq-hZ4Q-ThdQ+KD=uGgHq1KP0_tTsefG8qkFGi8Em-qw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 14:51:54 -0700
Kees Cook <keescook@chromium.org> wrote:

> > And how serious is the security vulnerability, in real-world terms?
> > Serious enough to risk this amount of bustage?
> 
> If they're running in mode "2" and they do not have a coredump pipe
> handler defined, local users can gain root access.

But the kernel can detect this case and avoid it?  If we do that at the same
time, we can avoid any mode=2 non-back-compatible breakage?
