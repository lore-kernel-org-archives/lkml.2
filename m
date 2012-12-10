Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2LJURU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:17:20 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:32805 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2LJURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:17:18 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXRuARVzBsdDufYUaJcp6Ta80WWb5nBuk_sATk52PgoTw@mail.gmail.com>
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
	<20121205210528.GA9047@sergelap>
	<CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
	<20121205222040.GB14884@sergelap>
	<50C13F0E.5010401@schaufler-ca.com>
	<20121207144233.GA6681@mail.hallyn.com>
	<CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
	<CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
	<CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
	<CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
	<20121210145950.GC8137@sergelap>
	<50C603F8.6070401@schaufler-ca.com>
	<CALCETrWNboHVRm_aZ-Fvqri6PW3C4FPfuLLe3-8q7+-vgEP2nw@mail.gmail.com>
	<50C6345C.8040804@schaufler-ca.com>
	<CALCETrUctrxm5Vy2WYXaQy3CyyJOGAQ78LYHbLzv+ua_rGxMDA@mail.gmail.com>
	<50C63D4C.9060703@schaufler-ca.com>
	<CALCETrXRuARVzBsdDufYUaJcp6Ta80WWb5nBuk_sATk52PgoTw@mail.gmail.com>
Date: Mon, 10 Dec 2012 12:17:17 -0800
X-Google-Sender-Auth: symfD3TIEZZlMENj33O4RmIb-YA
Message-ID: <CAGXu5jJ0S+rJ9+LsMzoDYmAUZjGU-NuN1Y0DwHN_MatbXG02jg@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:55 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Write a daemon.  Rig up wrappers for each setuid program to instead
> call into that daemon and have that daemon invoke the privileged
> program on behalf of the caller, with a sanitized environment.  Be
> annoyed by a few items on the "linux plumber's wish list" that make
> this rather difficult right now.

FWIW, this is something we'd like to do in Chrome OS. Dealing with
fs-attrs has traditionally been a pain, so this kind of simple passing
down of privilege would be much nicer. It means we'd have a
programmatic way to decide what privs a helper has, rather than having
to represent it in some way on-disk.

-Kees

-- 
Kees Cook
Chrome OS Security
