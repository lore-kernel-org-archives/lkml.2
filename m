Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2FOXDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:03:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab2FOXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:03:07 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ag8JG7z7P3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=5Kw0WcOmtGipjFZqil4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339801384.25903.36.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 15 Jun 2012 19:03:04 -0400
In-Reply-To: <87d350429z.fsf@gmail.com>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-4-git-send-email-namhyung@kernel.org>
	 <1339763971.13377.370.camel@gandalf.stny.rr.com> <87k3z843i9.fsf@gmail.com>
	 <1339800312.25903.29.camel@gandalf.stny.rr.com> <87d350429z.fsf@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-16 at 07:51 +0900, Namhyung Kim wrote:

> > Yeah, that is a problem, although we could perhaps teach ctags and etags
> > how to find them.
> >
> 
> Ok, then I'll go with yours.
> 

I think we can keep yours. I know [ce]tags can be taught to handle that
as well.

Do a search for 'sys_read' in the kernel. It brings you to:

SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)

Which means that it can be taught.

-- Steve


