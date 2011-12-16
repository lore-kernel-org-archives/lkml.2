Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833Ab1LPVnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:43:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1LPVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:43:43 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ZLzRVHDcXY0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=0CWTxZ2yh9-9CWDRXIcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324071820.23971.131.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: frank.rowand@am.sony.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com
Date: Fri, 16 Dec 2011 16:43:40 -0500
In-Reply-To: <1324029272.18942.73.camel@twins>
References: <4EEAB90D.3050504@am.sony.com> <1324029272.18942.73.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 10:54 +0100, Peter Zijlstra wrote:

> 
> We could just merge Catalin's stuff in -rt to give it a test ride and
> see if anything horrible happens.. :-)

I think Frank needs something in the stable-rt too. And that's not a
place to give experimental stuff a test ride.

I'll let Thomas give the final say in what goes into stable. I prefer to
not have things in stable that are not in mainline or in Thomas's tree.
But if Catalin's stuff is fine for his tree, I'll look for the non risky
solution for the stable-rt tree.


-- Steve


