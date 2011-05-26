Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1EZBRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:17:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63772 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab1EZBRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:17:09 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=inQdEuNhf_oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pLFooxhX5uaH7BxyBKsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid
 warnings on 32bit machine
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, liubo <liubo2009@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
In-Reply-To: <4DDDA7F5.9020001@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
	 <1301665762.2160.22.camel@gandalf.stny.rr.com>
	 <4D9C2FF6.7090607@cn.fujitsu.com>
	 <1303150309.7181.51.camel@gandalf.stny.rr.com>
	 <4DACE6E0.7000507@cn.fujitsu.com> <4DBA8C95.4000300@cn.fujitsu.com>
	 <1304264124.25414.1079.camel@gandalf.stny.rr.com>
	 <4DDDE9E6.7090303@cn.fujitsu.com>
	 <1306326464.1465.85.camel@gandalf.stny.rr.com>
	 <20110525091252.8899385e.randy.dunlap@oracle.com>
	 <1306342064.1465.101.camel@gandalf.stny.rr.com>
	 <4DDDA7F5.9020001@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 21:17:07 -0400
Message-ID: <1306372627.1465.131.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 09:08 +0800, Li Zefan wrote:
> Steven Rostedt wrote:

> Actually it's more than a compile warning fix.
> 
> After a variable is cast from u64 to u32 and passed to __print_symbolic(),
> we'll see incorrect result in the trace output.

Don't worry, I didn't even say a warning fix was not reason to get into
this merge window.

There was only two patches in my last pull request that were not fixing
a bug and/or warning, but adding enhancements. I rebased without them
and even added this patch and another bug fix patch to get ready to push
out.

After my ktest runs are done (I test each patch on x86_64 and x86_32,
and then compile test them on a bunch of other archs), I'll do another
git pull request for this merge window.

Thanks!

-- Steve


