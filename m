Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2LRXXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:23:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52677 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab2LRXXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:23:05 -0500
Date: Wed, 19 Dec 2012 00:22:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20121218232254.GM31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <20121218224331.GB4937@liondog.tnic>
 <CAE9FiQUnacMj5f0hs54BDstf1dMQdHxjU_oC7d8g+5+3Bze12w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQUnacMj5f0hs54BDstf1dMQdHxjU_oC7d8g+5+3Bze12w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On Tue, Dec 18, 2012 at 03:08:16PM -0800, Yinghai Lu wrote:
> On Tue, Dec 18, 2012 at 2:43 PM, Borislav Petkov <bp@alien8.de> wrote:
> > you don't care about properly written commit messages, as long as they work
> 
> It seems that you are quite upset somehow.

sorry if I've made the wrong impression, but I'm not upset at all - I
was simply asking.

> Writing changelog that everyone could understand seems not be possible
> for me. Even I tried harder and splt patches to small pieces.
>
> This patchset is still on going stage, and still need to check with
> kgdb guys. I sent v7 out for more broader review, as some or most guys
> like to check that in plain-text email instead of git branch.
>
> So don't worry, commit log problem will be addressed.

I understand all that but I shouldn't be telling you how the whole
process works: you write a patch addressing one logical thing at a time,
write a commit message explaining the reason for the patch and then send
it out to everyone for review.

During the review, you read review emails and if you agree with the
suggested changes, you incorporate them in your patchset. This is the
continuous improvement we do until the patchset is mergeable.

Now you say, writing understandable changelogs are not possible for you
- well, I had one changelog written for you and asked you whether this
is what you mean. You didn't say anything. If it were, you could've
added it to the commit message and thus hopefully make the patch more
understandable. And I'm not saying I can write better, but I'm trying
and sometimes it seems to work.

All I'm saying is, if you have trouble with writing commit messages, we
can write them for you and you can tell us whether they make sense or
not. And use those pieces which make sense. And learn along the way.
I mean, we're all learning here; hell, I'm learning a lot from your
patchset too.

This is why I tried to review it, it teaches me stuff.

And the main thing is, if you don't write proper commit messages and do
not explain your code, this thing grows into an unmaintainable mess and
we don't do that crap in Linux. We want this code to be understandable
to more people not to less.

This is all I'm saying, please write more understandable commit messages
and if you can't, then ask us - we're more than glad to help.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
