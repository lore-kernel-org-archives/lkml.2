Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2AWSMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:12:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60690 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AWSMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:12:23 -0500
MIME-Version: 1.0
In-Reply-To: <m1mx9epjkh.fsf@fess.ebiederm.org>
References: <20120121090644.GA31670@www.outflux.net>
	<m1mx9epjkh.fsf@fess.ebiederm.org>
Date: Mon, 23 Jan 2012 10:12:22 -0800
X-Google-Sender-Auth: PBKnqjo2bneRlV23Yiyv31cXUfQ
Message-ID: <CAGXu5jJ602kqVVrR4fARo4D4=mHcbjjBcFtCtdEjgqm56U2K1g@mail.gmail.com>
Subject: Re: [PATCH v2] sysctl: control functionality of /proc/pid/mem
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 6:41 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> +#ifdef CONFIG_PROC_FS
>    ^^^^^^^^^^^^^^^^^^^^^^
>
> That ifdef is entertaining.  CONFIG_SYSCTL depends on CONFIG_PROC_FS
> so which interesting case did you imagine this ifdef would be false?
> Did you test to ensure the code is not compiled in that interesting case?

I noticed that when I added it, and decided to err on the side of more
configs if some day /proc/sys got moved out of /proc. Anyway, I can
easily remove it. v3 coming up...

-Kees

-- 
Kees Cook
ChromeOS Security
