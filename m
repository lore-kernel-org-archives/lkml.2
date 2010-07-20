Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab0GTWpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:45:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58110 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab0GTWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:45:12 -0400
X-Authority-Analysis: v=1.1 cv=kjawQlkT3vujM0lFy4b69hWxQTW3SR1XdVtFii1ut0g= c=1 sm=0 a=t0X6yi0U7tQA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=ajsEqqg9IDDZJZ9eaFAA:9 a=Q1zf-qG8rQOW-LwqWeGm0eFYFnwA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/7] vmscan: convert direct reclaim tracepoint to
 DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100716110859.GH13117@csn.ul.ie>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com>
	 <20100716191508.7375.A69D9226@jp.fujitsu.com>
	 <20100716110859.GH13117@csn.ul.ie>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Jul 2010 18:45:08 -0400
Message-ID: <1279665908.4818.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 12:08 +0100, Mel Gorman wrote:
>  
> > +DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
> > +
> > +	TP_PROTO(unsigned long nr_reclaimed),
> > +
> > +	TP_ARGS(nr_reclaimed)
> > +);
> > +
> 
> Over 80 columns here too.
> 
> I know I broke it multiple times in my last series because I thought it
> wasn't enforced any more but I got called on it.

Note, The TRACE_EVENT() macros have a bit more leniency to the 80 column
rule.

-- Steve
 

