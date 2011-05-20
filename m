Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463Ab1ETRTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:19:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51202 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935236Ab1ETRTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:19:16 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=TwWXrjo8ZJIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tslaVK8-jnGl-umQihYA:9 a=PUjeQqilurYA:10 a=_RhRFcbxBZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: Steven Rostedt <rostedt@goodmis.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <BANLkTikfaKJfnDwQoFi9WLX6q+2HHe90HQ@mail.gmail.com>
References: <201105191526.31904.toralf.foerster@gmx.de>
	 <201105200937.15322.toralf.foerster@gmx.de>
	 <BANLkTik0oz6ppJvRpufaaiBL1pqcAxNHuA@mail.gmail.com>
	 <201105201042.15410.toralf.foerster@gmx.de>
	 <BANLkTikfaKJfnDwQoFi9WLX6q+2HHe90HQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 May 2011 13:19:13 -0400
Message-ID: <1305911953.1465.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 18:24 +0200, richard -rw- weinberger wrote:
> 2011/5/20 Toralf Förster <toralf.foerster@gmx.de>:
> >

> Here in futex_wake() happens a NULL pointer dereference.
> Steve, any ideas?
> 

Yes, if this is from the bisect, and does not contain the two commits
that I've posted in another email. Without those fixes, the futex code
will error and return without doing the proper work and cause all sorts
of bugs.

-- Steve


