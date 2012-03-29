Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab2C2RPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:15:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132Ab2C2RO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:14:57 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ujHqK8gl_DAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=LoHBucDaIXOJpwDHqT4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1333041294.23924.184.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 29 Mar 2012 13:14:54 -0400
In-Reply-To: <alpine.LFD.2.02.1203291902280.10113@tycho>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
	 <alpine.LFD.2.02.1203291902280.10113@tycho>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 19:03 +0200, John Kacur wrote:

> >  
> >  	mutex_lock(&ftrace_lock);
> >  
> > -	if (unlikely(ftrace_disabled))
> > -		goto out_unlock;
> > -
> >  	ret = __register_ftrace_function(ops);
> >  	if (!ret)
> >  		ret = ftrace_startup(ops, 0);
> >  
> > -
> >   out_unlock:
> >  	mutex_unlock(&ftrace_lock);
> >  	return ret;
> > -- 
> 
> If you're going to do this, then you can drop the label too.
> 

Yeah, can you resubmit with John's suggestion.

Thanks,

-- Steve


