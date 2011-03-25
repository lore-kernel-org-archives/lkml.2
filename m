Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab1CYDYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 23:24:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38549 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427Ab1CYDYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 23:24:45 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=tZjRFoWy3A4A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=jkfEzWBhShT9YVbxDpEA:9 a=gtjgUY07cW4OfH6L7Ip2tp3o6acA:4 a=CjuIK1q_8ugA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Mar 2011 23:24:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325032442.GA9313@home.goodmis.org>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324081816.GD30812@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324081816.GD30812@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:18:16AM +0100, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> s/NOT-// ?
> 

Perhaps because it is still in RFC context?

-- Steve

