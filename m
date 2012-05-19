Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2ESMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 08:25:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2ESMZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 08:25:57 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=mtloJUw6WWAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ccESZ9927CwFfQE8lG0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337430355.32434.0.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/15] [GIT PULL] tracing: Updates for 3.5
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Sat, 19 May 2012 08:25:55 -0400
In-Reply-To: <20120519101243.GA17997@gmail.com>
References: <20120518130858.392919640@goodmis.org>
	 <1337391816.7562.18.camel@gandalf.stny.rr.com>
	 <20120519101243.GA17997@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-19 at 12:12 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 2012-05-18 at 09:08 -0400, Steven Rostedt wrote:
> > > Ingo,
> > > 
> > > This should be my last set of changes for the next merge window.
> > 
> > Not quite :-)
> > 
> > You can hold off on pulling this. I want to add Masami's Acked-by tag,
> > and Vaibhav gave me two more patches. I'll run it through my own tests
> > and then do another pull request.
> 
> I already pulled them and they tested out fine. Please queue up 
> the two patches on top.

OK, will do. I actually found an old patch that should have gone in a
long time ago too. It's a minor clean up, so I'll add that one too.

-- Steve


