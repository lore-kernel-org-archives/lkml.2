Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2HCNAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:00:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62969 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2HCNAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:00:31 -0400
MIME-Version: 1.0
In-Reply-To: <e80f32ef-d6cf-48cc-9ddb-75d95bc9581e@email.android.com>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
	<CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
	<87pq7935w2.fsf@xmission.com>
	<CAFLxGvz0reQS=zfWeTz4a4xZVFeeu80VnP-efy7zCiPZVWzH-g@mail.gmail.com>
	<20120803110247.GB11952@moon>
	<501BC62A.4090308@parallels.com>
	<e80f32ef-d6cf-48cc-9ddb-75d95bc9581e@email.android.com>
Date: Fri, 3 Aug 2012 15:00:30 +0200
Message-ID: <CAFLxGvwnEC7O3Lf6PcU5qQO1H4NFeSRCWiy-u3mxmHCcPq==1A@mail.gmail.com>
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "spender@grsecurity.net" <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 2:58 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> The permissions on the syscall were fixed them withR ptrace_may_access.
>
> We have identified two legitimate use cases.
>
> It looks like it is time for someone to generate the path to remove the depreciation.
>
> Who is up for writing and testing that patch?

I'll send a patch.

-- 
Thanks,
//richard
