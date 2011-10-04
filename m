Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab1JDSht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:37:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab1JDShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:37:48 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=KLHn1Y0yDYBEymWMDT8A:9 a=vt8kMc8Kowp02n9M2mAA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 04 Oct 2011 14:37:45 -0400
In-Reply-To: <20111004182615.GA16224@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de>
	 <1317752148.18063.16.camel@gandalf.stny.rr.com>
	 <20111004182615.GA16224@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317753468.18063.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 11:26 -0700, Greg KH wrote:

> > What are git's "split" subject: lines?
> 
> Do the following:
>  $ git show --pretty=email 21d17dd2a377ba894f26989915eb3c6e427a3656
> 
> and look at how the Subject line is formatted:
> 	Subject: [PATCH] ASoC: Fix setting update bits for WM8753_LADC and
> 	 WM8753_RADC
> 
> Which is legal for email subject lines.  But quilt can't handle this and
> ends up thinking the data after the Subject: line is part of the patch
> text body and messes stuff up when doing 'quilt mail' later.
> 
> So I have to remember to edit the subject: lines all the time, and
> cringe when I forget.
> 
> Oh, then there's the issue of quilt not handling ',' in a Signed-off-by
> line as a valid email address name, but I've been living with that one
> for years...
> 

Hmm, while I'm currently working under the quilt hood, I'll see if I
could get some patches here to help you out ;)

-- Steve


