Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1CQViV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:38:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50567 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1CQViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:38:19 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=cjxWWOd7KoAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1ytC9bRqbYksj9LWoTYA:9 a=HYbRRt7QFdCknNbxn1HgRNqGKiMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: make checkpatch warn about memset with swapped arguments.
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110317141108.52697d81.akpm@linux-foundation.org>
References: <20110317045209.GA18656@redhat.com>
	 <20110317193645.GD14675@home.goodmis.org>
	 <20110317200215.GA4084@redhat.com>
	 <1300394224.16880.518.camel@gandalf.stny.rr.com>
	 <20110317141108.52697d81.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 17:38:16 -0400
Message-ID: <1300397896.16880.584.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 14:11 -0700, Andrew Morton wrote:
> On Thu, 17 Mar 2011 16:37:04 -0400

> 
> Dave's patch is tested (I assume), so it wins ;)

I did test mine :) Checked it out before posting. Although I didn't make
a patch out of it.

> 
> Maybe it's just me, but I think it would be better to use bzero() for
> this operation - it's more readable and it can't be screwed up.  Then
> checkpatch checks for memset(xxx, 0, xxx) and for memset(xxx, xxx, 0)
> and says "hey, use bzero".  

Honestly, I've never had the issues with memset. Maybe back in college.
But heh, whatever.

-- Steve


