Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2DIVdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:33:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40617 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab2DIVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:33:00 -0400
From: Paul Moore <paul@paul-moore.com>
To: Kees Cook <keescook@chromium.org>
Cc: libseccomp-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
Subject: Re: ANN: libseccomp
Date: Mon, 09 Apr 2012 17:32:57 -0400
Message-ID: <1580647.pAHyaBF6MS@sifl>
User-Agent: KMail/4.8.2 (Linux/3.3.1-gentoo; KDE/4.8.2; x86_64; ; )
In-Reply-To: <CAGXu5jL5nAY4=5OKhA6VPdrzkUjVuBTcLQuMxUSEv_=N=ohbzQ@mail.gmail.com>
References: <1540670.AFBi1SpGoi@sifl> <CAGXu5jL5nAY4=5OKhA6VPdrzkUjVuBTcLQuMxUSEv_=N=ohbzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 09, 2012 12:16:30 PM Kees Cook wrote:
> On Mon, Apr 9, 2012 at 11:58 AM, Paul Moore <paul@paul-moore.com> wrote:
> > With the seccomp patches finally stabilizing a bit, it seems like now is a
> > good time to announce libseccomp: a library designed to make it easier to
> > create complex, architecture independent seccomp filters.
> > 
> >  * http://sourceforge.net/projects/libseccomp/
> >  * git clone git://git.code.sf.net/p/libseccomp/libseccomp
> 
> This looks really great; nice work!

Thanks.

> I see that the arch check happens during _gen_bpf_build_bpf(), which
> is excellent. Do you have any thoughts about including a call to
> prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) by default as well?

That is a good question, and I guess it comes down to another question of if 
anyone would want to use seccomp without NO_NEW_PRIVS.  If the answer is no 
then I'm comfortable adding it into the seccomp_load() function; however, if 
the answer is yes we might want to do something different.

I haven't given much thought to this yet, so if you or anyone else feels 
strongly about the issue - either pro or con - I'd appreciate hearing the 
argument.

-- 
paul moore
www.paul-moore.com

