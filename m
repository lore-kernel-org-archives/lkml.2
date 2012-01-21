Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab2AUR3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:29:16 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:36325 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750702Ab2AUR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:29:12 -0500
Message-ID: <4F1B0399.5000801@xenotime.net>
Date: Sat, 21 Jan 2012 10:27:37 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] sysctl: control functionality of /proc/pid/mem
References: <20120121090644.GA31670@www.outflux.net>
In-Reply-To: <20120121090644.GA31670@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 01:06 AM, Kees Cook wrote:
> Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
> allowed to work: 0: disabled, 1: read only, 2: read/write.

Maybe mention that the default is 2 (or did you mean to change that sooner
or later?).


> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/sysctl/kernel.txt |   14 ++++++++++++++
>  fs/proc/base.c                  |   14 +++++++++++++-
>  kernel/sysctl.c                 |   14 ++++++++++++++
>  3 files changed, 41 insertions(+), 1 deletions(-)

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
