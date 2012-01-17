Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2AQCHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:07:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2AQCHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:07:38 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ravTz9YwjkQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=V0V3zUh2Txx9viCZyKAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326766055.7642.181.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Mon, 16 Jan 2012 21:07:35 -0500
In-Reply-To: <20120117014209.GB24200@somewhere.redhat.com>
References: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
	 <1325495060-6402-1-git-send-email-jolsa@redhat.com>
	 <1325495060-6402-3-git-send-email-jolsa@redhat.com>
	 <20120117014209.GB24200@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 02:42 +0100, Frederic Weisbecker wrote:
>  
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 523640f..0d43a2b 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -35,12 +35,14 @@ enum {
> >  	FTRACE_OPS_FL_ENABLED		= 1 << 0,
> >  	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
> >  	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
> > +	FTRACE_OPS_FL_CONTROL		= 1 << 3,
> 
> Please comment the role of this flag. In fact it would be nice to have
> a comment that explains all these. GLOBAL and DYNAMIC don't actually give
> much clues alone.

Someone else asked about commenting these (was it you?). I probably
should, as it is confusing to what they are used for.

I just figured every just figures it out by looking at the code ;-)

-- Steve


