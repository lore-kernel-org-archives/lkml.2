Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1J0Miz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:38:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1J0Miz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:38:55 -0400
Date: Thu, 27 Oct 2011 14:37:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
Message-ID: <20111027123713.GB22032@elte.hu>
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com>
 <CAOJsxLH-O8+Fx=VLsoXhVLNtXWD_1eVrUMOgbk2DODbrwPAzhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLH-O8+Fx=VLsoXhVLNtXWD_1eVrUMOgbk2DODbrwPAzhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Oct 27, 2011 at 3:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > This patch adds 'make kvmconfig' which allows to add KVM guest support
> > to a config file.
> >
> > This allows for easier testing of configurations under virtualized
> > environments.
> >
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Suggested-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>
> 
> Btw, Michal, if people are OK with the patch I'd really love to 
> take this patch in my kvmtool git tree to have it contained in a 
> single pull request.

I like the feature - i hope it's expressed in the right Kbuild-ish 
fashion.

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
