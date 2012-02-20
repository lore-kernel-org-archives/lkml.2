Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2BTTr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:47:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2BTTr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:47:58 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=cmBuszERE20A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pGLkceISAAAA:8 a=6rqHouBjAAAA:8 a=y3-NHI71wv_OTvW8qIIA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=TAmEwCHjoHMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329767276.25686.40.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace: don't print an extra separator of flags
From: Steven Rostedt <rostedt@goodmis.org>
To: avagin@gmail.com
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 20 Feb 2012 14:47:56 -0500
In-Reply-To: <4F42A158.4090501@gmail.com>
References: <1329650167-480655-1-git-send-email-avagin@openvz.org>
	 <1329761354.25686.32.camel@gandalf.stny.rr.com>
	 <4F42A158.4090501@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 23:39 +0400, avagin@gmail.com wrote:
> On 02/20/2012 10:09 PM, Steven Rostedt wrote:
> > On Sun, 2012-02-19 at 14:16 +0300, Andrew Vagin wrote:
> >> From: Andrey Vagin<avagin@openvz.org>
> >>
> >> It occurs if __print_flags is used more than once
> >
> > Hi, which tracepoint does this? I like to see what the issue is.
> 
> The mainstream kernel doesn't have such trace-point, but I have.

Could you send me that patch. Or a change to the kernel that shows the
problem.

> 
> Do you want to say that this bug should not be fixed in this case? :)

No, if it is a issue with the infrastructure, even though nothing
triggers the problem, it should still be fixed, especially if new code
in the future will be triggering it.

-- Steve


