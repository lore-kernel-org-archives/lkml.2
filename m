Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1HFBqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 21:46:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab1HFBqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 21:46:42 -0400
Date: Fri, 5 Aug 2011 18:49:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] connector: add comm change event report to proc
 connector
Message-Id: <20110805184920.2dca116f.akpm@linux-foundation.org>
In-Reply-To: <CAMW3pwZqRRZKpDeGYbEEGV-8GMAUHHWvGNje1orHs9YGp7ErUA@mail.gmail.com>
References: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
	<20110803211225.GA24876@ioremap.net>
	<CAMW3pwZqRRZKpDeGYbEEGV-8GMAUHHWvGNje1orHs9YGp7ErUA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011 15:16:38 +0300 Vladimir Zapolskiy <vzapolskiy@gmail.com> wrote:

> On Thu, Aug 4, 2011 at 12:12 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> > On Tue, Aug 02, 2011 at 09:46:51PM +0300, Vladimir Zapolskiy (vzapolskiy@gmail.com) wrote:
> >> This change adds an event to monitor comm value changes of tasks. Such
> >> an event becomes vital, if someone desires to control threads of a
> >> process in different manner.
> >
> >> Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> >> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >
> > Looks good.
> > Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> >
> 
> Thanks a lot, hopefully that's the end of my foray into connector :)
> 
> Andrew, unfortunately I can't find a proper tree for integration,

Normally davem and netdev list.  I use scripts/get_maintainer.pl and,
when I don't believe its output (often), `git whatchanged'.

> could I kindly ask you to pick up the change, if it's possible for
> you?

yep, I'll grab it.  I'm presently somewhere in the wilds of Alaska so
there will be delays ;)
