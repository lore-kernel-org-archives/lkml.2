Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2CWTIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:08:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37810 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2CWTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203231926000.2542@ionos>
References: <20120323175855.GA23668@www.outflux.net>
	<alpine.LFD.2.02.1203231926000.2542@ionos>
Date: Fri, 23 Mar 2012 12:08:38 -0700
X-Google-Sender-Auth: XcaCCGpx2QPyjeF65xzwpC75IRI
Message-ID: <CAGXu5j+BLTA4nvNWHJbjWeOzQpjJRss=L4FP4drPcF4dwb8cGQ@mail.gmail.com>
Subject: Re: [PATCH] futex: mark get_robust_list as deprecated
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        kernel-hardening@lists.openwall.com, spender@grsecurity.net
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 11:27 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 23 Mar 2012, Kees Cook wrote:
>
>> Notify get_robust_list users that the syscall is going away.
>
> That want's an entry in Documentation/feature-removal-schedule.txt as
> well.

Ah! Yes, I will send a v2.

> That's on top of your previous one, right ?

Yup. :)

-Kees

-- 
Kees Cook
ChromeOS Security
