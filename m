Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0HJHdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:33:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab0HJHdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:33:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 8bit
From: Roland McGrath <roland@redhat.com>
To: Yegor Yefremov <yegorslists@googlemail.com>
X-Fcc: ~/Mail/linus
Cc: Roland Dreier <rdreier@cisco.com>, Tiago Maluta <tiago.maluta@gmail.com>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
In-Reply-To: Yegor Yefremov's message of  Tuesday, 10 August 2010 08:43:18 +0200 <AANLkTikvRqTR6TjP9H4-_RHhax24YRPv9PCxn165RTWs@mail.gmail.com>
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
	<20100621120613.86cad1a4.akpm@linux-foundation.org>
	<4C1FC35C.8090201@suse.cz>
	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>
	<AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>
	<adaocdg3fng.fsf@roland-alpha.cisco.com>
	<20100805222623.39A3240208@magilla.sf.frob.com>
	<AANLkTikvRqTR6TjP9H4-_RHhax24YRPv9PCxn165RTWs@mail.gmail.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100810073317.F2A8C40542@magilla.sf.frob.com>
Date: Tue, 10 Aug 2010 00:33:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Aug 6, 2010 at 12:26 AM, Roland McGrath <roland@redhat.com> wrote:
> >> Yes, this make sense to me.  It's not clear to me why we ever needed
> >> the conditional assignment of an empty CROSS_COMPILE (that code predates
> >> the start of git history) [...]
> >
> > Perhaps someone used make --warn-undefined-variables.
> 
> Are there any other comments or is the patch valid? Should I resend it
> as a new thread?

The patch is fine.  The comments were just about how it might have gotten
to be how it was before now.

Thanks,
Roland
