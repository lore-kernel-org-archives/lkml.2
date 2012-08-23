Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2HWPRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:17:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2HWPRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:17:11 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dpSlj_obXwQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=elah4ftNUEAA:10 a=meVymXHHAAAA:8 a=da0iqJbVSrZr_0pu1rIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345735029.5069.60.camel@gandalf.local.home>
Subject: Re: [PATCH] tools lib traceevent: Modify header to work in C++
 programs
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 23 Aug 2012 11:17:09 -0400
In-Reply-To: <87boi3ifs9.fsf@sejong.aot.lge.com>
References: <1345590800.5069.17.camel@gandalf.local.home>
	 <87boi3ifs9.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 15:47 +0900, Namhyung Kim wrote:
> Hi, Steve
> 
> On Tue, 21 Aug 2012 19:13:20 -0400, Steven Rostedt wrote:
> > tools lib traceevent: Modify header to work in C++ programs
> >
> > Replace keyword "private" from event-parse.h to allow it to be
> > used in C++ programs.
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> >
> > diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> > index 5772ad8..c28713b 100644
> > --- a/tools/lib/traceevent/event-parse.h
> > +++ b/tools/lib/traceevent/event-parse.h
> > @@ -49,7 +49,7 @@ struct pevent_record {
> >  	int			cpu;
> >  	int			ref_count;
> >  	int			locked;		/* Do not free, even if ref_count is zero */
> > -	void			*private;
> > +	void			*r_private;
> 
> This r_ (and p_) prefix make it inconsistent with others. How about
> simply using 'priv' instead?

Sure, sounds good.

I'll update and resend.

Thanks!

-- Steve

