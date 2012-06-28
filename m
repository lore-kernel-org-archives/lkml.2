Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2F1ByT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:54:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2F1ByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:54:18 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EvKSwpK77UAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=RbKYJHrYPF3FBNR2MQsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340848455.16702.57.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 27 Jun 2012 21:54:15 -0400
In-Reply-To: <20120628014823.GA2025@kroah.com>
References: <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop>
	 <1340810038.16702.16.camel@gandalf.stny.rr.com>
	 <1340810283.16702.19.camel@gandalf.stny.rr.com>
	 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
	 <1340869133.876.10.camel@mop> <20120628014823.GA2025@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 18:48 -0700, Greg Kroah-Hartman wrote:

> And this solves the boot problem I was seeing, thanks a lot for fixing
> that issue.
> 
> Steven, any objections to me taking this patch?
> 

My box crashed on the earlier version too. Let me run some tests on it
first, and then I'll give my Tested-by and Acked-by if it succeeds, and
I don't see anything wrong with it as I give it further review.

-- Steve


