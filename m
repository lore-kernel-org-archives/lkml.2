Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1ERBYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:24:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64739 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab1ERBYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:24:06 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=XYJHFtupD_QA:10 a=7JApkIGHcZkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XhHvhA-JzRRLiRPp-MoA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 17 May 2011 21:24:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Hillf Danton <dhillf@gmail.com>, Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: fix how RT task is pulled
Message-ID: <20110518012404.GC23940@home.goodmis.org>
References: <BANLkTinw9LLiGD788+6AvbE+54jyVRUwBg@mail.gmail.com>
 <BANLkTikPhwajRBZ-dx46NnobOu10AmXoSg@mail.gmail.com>
 <BANLkTimOfL9iWFEhV6tQcTBM+V5N3b+-YA@mail.gmail.com>
 <1305656829.6238.41.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305656829.6238.41.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 08:27:09PM +0200, Mike Galbraith wrote:
> > >
> > Well, why is it going no head if not overloaded?
> 
> To avoid examining masks (maybe huge) routinely.  Challenge is to
> improve oddball case (overload) without injuring the common case.

Correct.

-- Steve

