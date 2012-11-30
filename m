Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2K3VqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:46:05 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40994 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2K3VqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:46:02 -0500
MIME-Version: 1.0
In-Reply-To: <50B90F4F.7070400@zytor.com>
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org>
 <1354301523-5252-2-git-send-email-vpalatin@chromium.org> <CA+55aFz4M4GmQbUkD1dhTkLTYka4H+T_phrsXgx+eGe8g9iLYA@mail.gmail.com>
 <50B90B31.3000907@zytor.com> <CA+55aFyoAq+w6eNAyOJ00cpFEaGE=eKzMMtr9kEtMuUU820oYg@mail.gmail.com>
 <50B90E4D.8010604@zytor.com> <CAP_ceTxmMhQeDi=x9HmYke85hKMg3_YhbXSnfDC12rOcocQJpA@mail.gmail.com>
 <50B90F4F.7070400@zytor.com>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Fri, 30 Nov 2012 13:45:42 -0800
X-Google-Sender-Auth: t7dHdiWNAcVvWCHz2WcviAby2x0
Message-ID: <CAP_ceTz-63+vpg3dMr8Xc2dek0SUWvV3nJAwQWj_GYP07Wcsgg@mail.gmail.com>
Subject: Re: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 11:55 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 11/30/2012 11:54 AM, Vincent Palatin wrote:
> >>
> > I have done a patch v2 according to your suggestions.
> > I will run the testing on it now.
> > I probably need at least 2 to 3 hours to validate it.
> >
>
> That would be super.  Let me know and I'll queue it up and send a pull
> request with this and a few more urgent things to Linus.


I have done 1000+ cycles so far with patch v3 (on 4-core Ivybridge and
no eagerfpu),
and did not hit my issue.
I let the testing going on,
but wrt the issue after suspend, this fixes it with very high probability
(ie I have never done that many cycles without hitting the issue).

-- 
Vincent
