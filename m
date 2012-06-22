Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2FVVJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:09:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62205 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2FVVJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120622125551.269552c2.akpm@linux-foundation.org>
References: <20120622192413.GA5774@www.outflux.net>
	<20120622125551.269552c2.akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 14:09:28 -0700
X-Google-Sender-Auth: YGTnwSI2MyHlUk4tE9eewzR1AG0
Message-ID: <CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com>
Subject: Re: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:55 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 22 Jun 2012 12:24:13 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> The value
>> of suid_dumpable=2 is now historic, and attempting to set this sysctl
>> value returns -EINVAL.
>
> This sounds a bit harsh - will it not cause existing configurations to
> immediately break?  If so, would it not be better to retain the =2 mode
> for a while, and emit a nice warning when it is set?

I view it as a security vulnerability, so I'd rather see it
eliminated. I see "=1" as a security vulnerability too, but at least
that's well-known to be a bad idea. The "=2" mode has been assumed to
be safe, but it isn't.

-Kees

-- 
Kees Cook
Chrome OS Security
