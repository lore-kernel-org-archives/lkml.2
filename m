Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595Ab2FVPar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:30:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367Ab2FVPan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <87ipejo2am.fsf@xmission.com>
References: <20120622000049.GA7877@www.outflux.net>
	<87ipejo2am.fsf@xmission.com>
Date: Fri, 22 Jun 2012 08:30:41 -0700
X-Google-Sender-Auth: OJHhwWFrIUINx3yHxh6a3-b0OwM
Message-ID: <CAGXu5jJrYywN3Y93efpyxnu8AnhWsSpFuogb8=GUkOYgsH01rQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs: introduce pipe-only dump mode suid_dumpable=3
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, Marcel Holtmann <marcel@holtmann.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, Jun 22, 2012 at 7:21 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> This patch introduces suid_dumpable=3 to allow privilege-changed processes
>> to be dumped only to a pipe handler (and not directly to disk). The value
>> of suid_dumpable=2 is now deprecated, and attempting to set this sysctl
>> value returns -EINVAL.
>
> Your patch descriptoin is wrong.  Deprecate means something is encouraged
> not to be used not that the functionality is removed.  I think what
> you are trying to say is that the value suid_dumpable=2 is now historic.
>
> Your implementation is absolutely gross.  Reading the value from
> twice from user space??    Is an if statement that hard to code?

I will rework this and resend.

-Kees

-- 
Kees Cook
Chrome OS Security
