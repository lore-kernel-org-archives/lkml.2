Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2CBDl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:41:57 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42803 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758099Ab2CBDlz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:41:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of wad@dataspill.org designates 10.152.128.163 as permitted sender) smtp.mail=wad@dataspill.org
MIME-Version: 1.0
X-Originating-IP: [173.164.30.65]
In-Reply-To: <20120302141038.aaafc42b59ac7cf95d3553ed@canb.auug.org.au>
References: <1330559620-23543-1-git-send-email-wad@chromium.org>
	<20120301233712.GS3990@outflux.net>
	<20120302114705.0a9542e138927897f16282ca@canb.auug.org.au>
	<CAGXu5jL0OXR5MOePFe=GT4_X5rdH8RNjQPqYXdbqsqfijUsEqA@mail.gmail.com>
	<20120302141038.aaafc42b59ac7cf95d3553ed@canb.auug.org.au>
Date: Thu, 1 Mar 2012 21:41:51 -0600
X-Google-Sender-Auth: _SjrsFlJUxEYNJVpQGamueAnl8g
Message-ID: <CABmXcB83uFMUFUuRKCtkMjU2KLv7N4JB08qzZLVDdT=CStmQjw@mail.gmail.com>
Subject: Re: [PATCH v12 01/13] sk_run_filter: add support for custom load_pointer
From: Will Drewry <wad@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kees Cook <keescook@chromium.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 9:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Kees,
>
> On Thu, 1 Mar 2012 16:57:49 -0800 Kees Cook <keescook@chromium.org> wrote:
>>
>> Unfortunately, yes, it does -- there were both ptrace changes and prctl changes.
>>
>> And at least the ptrace changes are, IIRC, in -mm, which has no tree.
>> :P Given that, what's the best thing for me to do for this to be easy
>> for you to pull?
>
> Does this set of patches *depend* on functionality provided by those, or
> just produce conflicts against the other changes?  If it is just
> conflicts, then base your tree on Linus and I and (he when it comes to
> it) can fix the conflicts as needed (with some hints if you think it is a
> good idea i.e. is the conflicts are particularly complex).

No explicit dependency.   It's just a conflict in how ptrace options
are set, defined, and masked (and STOP being renumbered).  Other than
the ptrace changes, the whole series patches cleanly onto both trees.
The resolved version is less code and easier to read, so I don't
suspect it'll be a challenge at all.

thanks!
