Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab2EOSOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:14:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab2EOSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:14:45 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=huzqtivG31QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=sPJqCj5OSEZy9ZfvzqMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337105683.14207.344.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 15 May 2012 14:14:43 -0400
In-Reply-To: <alpine.LFD.2.00.1205151956500.8461@localhost6.localdomain6>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1205151956500.8461@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 20:00 +0200, John Kacur wrote:
> 

> It looks interesting. I wanted to compile it and test it, but started 
> running into some problems, I fixed two simple things, but wanted to wait
> to see if you would follow Peter's suggestion for lockdep before
> proceeding too far.

I wouldn't bother compiling it with lockdep (yet), as it is completely
broken. I'll need to implement Peter's suggestion.

-- Steve


