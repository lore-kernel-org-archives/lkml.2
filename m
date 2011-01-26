Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1AZXKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:10:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab1AZXKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:10:53 -0500
Date: Wed, 26 Jan 2011 15:10:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-Id: <20110126151017.ed9e627c.akpm@linux-foundation.org>
In-Reply-To: <20110126145703.a0f5add5.rdunlap@xenotime.net>
References: <20110125235700.GR8008@google.com>
	<20110126144910.ce0646ec.akpm@linux-foundation.org>
	<20110126145703.a0f5add5.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 14:57:03 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> > I'm a bit surprised that this wasn't already tunable at boot-time
> > and/or at runtime.
> 
> 
> As WANG Cong replied:
> 
> Why? We already have "loglevel=" kernel parameter.

That's different.

Mandeep's patch addresses printks which didn't have a facility level. 
Longer-term, all these should be fixed, so they have an explicit
facility level.  I suppose that short-term it would make sense to
prefer to blurt these messages onto the console rather than hiding
them.  Because they might be important.  And if they weren't important,
they will then irritate enough people to get themselves fixed.


