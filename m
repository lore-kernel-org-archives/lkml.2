Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1FJU5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:57:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393Ab1FJU5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <4DF28274.3000708@suse.cz>
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
 <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com> <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
 <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com> <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
 <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com> <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
 <20110610100339.GE22466@vostochny.stro.at> <BANLkTin+RBL9aYzWeTBZ2Fj_m+8WuA_Ckg@mail.gmail.com>
 <4DF28274.3000708@suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Jun 2011 13:56:44 -0700
Message-ID: <BANLkTi=dUjVvLmvcvjibYTxWYDCX-WOy_A@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
To: Michal Marek <mmarek@suse.cz>
Cc: maximilian attems <max@stro.at>, Ray Lee <ray-lk@madrabbit.org>,
        Arnaud Lacombe <lacombar@gmail.com>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 1:45 PM, Michal Marek <mmarek@suse.cz> wrote:
>
> So would pull the branch if I revert "kbuild: Hack for depmod not
> handling X.Y versions"?

Umm. I already pulled it yesterday. The reason I then replied to the
pull request was to report that it isn't enough to actually get things
working..

                    Linus
