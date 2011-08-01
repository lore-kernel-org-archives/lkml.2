Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1HATDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:03:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47711 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1HATDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:03:47 -0400
Date: Mon, 1 Aug 2011 23:03:41 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        torvalds@linux-foundation.org, Marc Zyngier <maz@misterjones.org>
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs.
 threads)
Message-ID: <20110801190341.GA6898@albatros>
References: <20110801180151.GA26686@albatros>
 <20110801112021.25ec9041.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801112021.25ec9041.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are we talking about init_ipc_ns.ids[] here?  If so, did you try
> initializing the three rwsems at compile-time?
> 
> That's rather a nasty hack though.  It'd be better to run the mystery
> init function before starting the threads.

Looks like it solves the race.  However, I think it should be solved on
another level.  Other bugs might be hidden with this race.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
