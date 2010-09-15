Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0IOEw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:52:26 -0400
Received: from 1wt.eu ([62.212.114.60]:44864 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0IOEwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:52:25 -0400
Date: Wed, 15 Sep 2010 06:52:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.37.10 + 2.4 EOL plans
Message-ID: <20100915045222.GA20654@1wt.eu>
References: <20100906054515.GA22864@hera.kernel.org> <SNT125-W58FE492CE393C28E2D5249C3780@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SNT125-W58FE492CE393C28E2D5249C3780@phx.gbl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 03:19:54PM -0700, Yuhong Bao wrote:
> 
> OK, I will bite.
> Why are you still using kernel 2.4?

One word : stability.

Many people don't need all the fancy new features of 2.6 and can't afford
to reboot their systems every two weeks to apply the last bunch of fixes.
It's quite common to encounter 2.4 systems with 2 years of uptime in
production. Some users even ship it in embedded products where it's
impossible to update the system after it's shipped (no internet connectivity).
With 2.4, they're assured they won't encounter stability problems.

Some other users still use it for security reasons. 2.6 offers a wider
attack vector range and in practice, new locally exploitable vulnerabilities
are discovered every few weeks-months. I'm not saying that there aren't on
2.4, but since the code is frozen, it's been long since we last got one and
there's no reason to introduce new ones.

In fact, 2.4 is now occupying a similar place as OpenBSD : the type of
system you install once and never touch anymore.

Regards,
Willy

