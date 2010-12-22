Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0LVImB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:42:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45952 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751868Ab0LVImA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:42:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18F1pJuePcFZr3zyPxeDHMoxRLDkqcZyEZHbqRYcF
	1YLUEAqD41fhQR
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miklos Vajna <vmiklos@frugalware.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        systemd-devel@lists.freedesktop.org
In-Reply-To: <1293006589.2170.41.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 09:41:51 +0100
Message-ID: <1293007311.11370.172.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 09:29 +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 01:22 +0100, Miklos Vajna wrote:
> > Please let me know if you need more info.
> 
> What distro are you using? it looks like systemd is involved and I'm
> actively avoiding anything using that crap.

Heh, gearing up to hunt a bug it triggers, just doing all I had to do to
get the thing built and installed blew my box _all up_.  I still have
smoldering bits lying about a week later.

	-Mike

