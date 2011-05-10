Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1EJM3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:29:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab1EJM3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m/98ZiTRYo783qp0I1vI7m+gQGqRuDW+KMTIW6oCwx58mXkyxqJAfXhY20HdkYhj1m
         Fy+WddLiYKwIztb5MN78croTH20LkOnmp7qrOHr/BbeRRB2hbv6NLpnOwaTOi/CCoU1S
         FyE+Y8yidQi+DUpl1kK0B8NLvH7VYIT99xC1I=
MIME-Version: 1.0
In-Reply-To: <1305016329.2914.22.camel@laptop>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
	<1305016329.2914.22.camel@laptop>
Date: Tue, 10 May 2011 20:29:35 +0800
Message-ID: <BANLkTik0NBxzQY2Jsx1M4pDUGLQJ0a2AuA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 4:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> If you're interested in this area of the scheduler, you might want to
> have a poke at:
>
> http://marc.info/?l=linux-kernel&m=130218515520540
>
> That tries to rewrite the CONFIG_NUMA support for the sched_domain stuff
> to create domains based on the node_distance() to better reflect the
> actual machine topology.
>
Hi Peter

Thank you very much for sharing the info.

Hillf
