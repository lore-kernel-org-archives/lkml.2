Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966454Ab2JZU3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:29:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44710 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966414Ab2JZU3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:29:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/AULgccfvAEN74G9cnugmgU3EimGhv1dbqc4vz1b
	FfGSwR9fPH0HTr
Message-ID: <1351283371.16639.111.camel@maggy.simpson.net>
Subject: Re: [PATCH] sched, autogroup: fix kernel crashes caused by runtime
 disable autogroup
From: Mike Galbraith <efault@gmx.de>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Xiaotian Feng <dannyfeng@tencent.com>, Ingo Molnar <mingo@redhat.com>
Date: Fri, 26 Oct 2012 13:29:31 -0700
In-Reply-To: <1350736696.5123.24.camel@maggy.simpson.net>
References: <1350635770-9189-1-git-send-email-xtfeng@gmail.com>
	 <1350654126.2768.5.camel@twins>
	 <CAJn8CcE5McFB-FH981Pj+eahNOt8ck3ncJwD4xocU_LrAtjBHA@mail.gmail.com>
	 <1350736696.5123.24.camel@maggy.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 08:38 -0400, Mike Galbraith wrote:

> So what I would do is either let the user decide once at boot, in which
> case if off, creating groups would be stupid), or, just rip autogroup
> completely out, since systemd is taking over the known universe anyway.

I'm traveling, but have somewhat functional connectivity ATM, so..

Peter: which would prefer.  Simple noautogroup -> autogroup one time
only boottime enable, and autogroup lives on (I like it for my laptop)
with backport for stable, or fix stable as above, and whack it upstream
as annoyance since systemd (one daemon to bind them..) is being adopted
everywhere?

(other?.. fully function on/off switch?  revert 800d4d30?)

-Mike

