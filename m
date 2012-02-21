Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2BUOsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:48:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2BUOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:48:21 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=3ODyh8mAtCyeJL9BtQsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329835698.25686.60.camel@gandalf.stny.rr.com>
Subject: Re: RAS trace event proto
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 09:48:18 -0500
In-Reply-To: <20120221141231.GA15515@aftab>
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com>
	 <20120221141231.GA15515@aftab>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 15:12 +0100, Borislav Petkov wrote:

> > Also, folding everything into just one string prevents (or make hard) the usage of
> > the perf filters, for example, to filter only the errors at the memory controller 1.
> 
> Huh, because you can't grep through the trace anymore...?
> 

I believe Mauro is talking about the tracing filters used by both perf
and ftrace that lets you ignore trace events when the contents of the
event does not match the filter. This is filtering out events before
they go to the buffer.

-- Steve


