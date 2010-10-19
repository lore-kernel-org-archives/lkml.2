Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0JSNMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:12:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46007 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752030Ab0JSNMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:12:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Ta1MA83TT+yi/PHjq8AreyfurgJFddxkawMkwzL
	6jl1My3fOoAmtP
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101019115648.GD25371@elte.hu>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <20101019115648.GD25371@elte.hu>
Content-Type: text/plain
Date: Tue, 19 Oct 2010 15:12:32 +0200
Message-Id: <1287493952.24189.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 13:56 +0200, Ingo Molnar wrote:

> Could this feature realistically do block IO isolation as well? It's always annoying 
> when some big IO job is making the desktop jerky. Especially as your patch is 
> selecting the block cgroup feature already:
> 
> +       select BLK_CGROUP

I know my cgroup pgid config helps a bunch with rummaging in my email
while other IO is going on.  I've been attributing that to BLK_CGROUP,
but have no proof.

	-Mike

