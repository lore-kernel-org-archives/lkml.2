Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab2CMSNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:13:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27673 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286Ab2CMSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:13:45 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=WdRX5nqvG-kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ClAIWt7bDBJgIh455q8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331662422.25686.662.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT] preempt: Define preempt_check_resched_rt() for non
 PREEMPT config
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Tue, 13 Mar 2012 14:13:42 -0400
In-Reply-To: <CAONaPpEFOrYFH9=HX+QUweGKqxXw2GUmj9+BAzwmxFtyJX=p+w@mail.gmail.com>
References: <1331607058.25686.660.camel@gandalf.stny.rr.com>
	 <CAONaPpEFOrYFH9=HX+QUweGKqxXw2GUmj9+BAzwmxFtyJX=p+w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 14:32 +0100, John Kacur wrote:

> This is the same patch I sent for v3.2.9-rt17. (where you complained
> because I gave clark a SOB instead of a Tested-by:) I see that
> #define preempt_check_resched()
> without the _rt has been shuffled to a more logical spot which is the
> only way I recognized that you mean this for v3.0.23-rt.

Actually it should be for 3.2-rt, my mistake to have done it against
3.0-rt, as the only person with the bug in 3.0-rt is me (It failed my
initial tests).

> 
> Could we please start to specify the rt-kernel version in these patches?

The fix was for Thomas.

-- Steve


