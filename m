Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750828Ab1COEGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:06:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38885 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1COEGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:06:13 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=6NiH-iD3OOyMwQEQ5rYA:9 a=UMxJkc2i080T78kkFXj0QX0iQ48A:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 15 Mar 2011 00:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.38
Message-ID: <20110315040610.GC23876@home.goodmis.org>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
 <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 08:13:38PM -0700, David Rientjes wrote:
> This kernel includes a broken commit that was merged a couple of hours 
> before release:
> 
> commit dc1b83ab08f1954335692cdcd499f78c94f4c42a
> Author: Oleg Nesterov <oleg@redhat.com>
> Date:   Mon Mar 14 20:05:30 2011 +0100
> 
>     oom: oom_kill_process: fix the child_points logic
>

Don't worry. If you download the patch for 2.6.38, you'll see that the
revert was in the final release.

Woo hoo, ketchup is useful again!

-- Steve

