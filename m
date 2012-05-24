Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322Ab2EXVZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:25:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965213Ab2EXVZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:25:16 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=aPRl181HrfigEvSmQzUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337894714.13348.206.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kbuild@vger.kernel.org
Date: Thu, 24 May 2012 17:25:14 -0400
In-Reply-To: <20120524211520.GA2800@redhat.com>
References: <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337880914.13348.189.camel@gandalf.stny.rr.com>
	 <20120524184728.GA13201@redhat.com>
	 <1337885672.13348.194.camel@gandalf.stny.rr.com>
	 <20120524191147.GA13936@redhat.com>
	 <1337887495.13348.195.camel@gandalf.stny.rr.com>
	 <20120524200541.GA6552@redhat.com>
	 <1337890690.13348.199.camel@gandalf.stny.rr.com>
	 <1337891586.13348.202.camel@gandalf.stny.rr.com>
	 <20120524211520.GA2800@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 17:15 -0400, Dave Jones wrote:
> On Thu, May 24, 2012 at 04:33:06PM -0400, Steven Rostedt wrote:
> 
>  > I'm kicking off the ktest that initially caused this issue hoping that
>  > it reproduces the bad tree again.
>  > 
>  > BTW, did you happen to upgrade gcc or anything? The ktest I run does
>  > test against different gcc's and I don't think I had it do a make clean
>  > between the switch. That may be the cause of this problem too :-?
> 
> No gcc updates. It's a Fedora 17 box, so there's been hardly any updates this
> last week or so as things have been frozen leading into the release.
> 

I'm currently running a ktest that is similar to what I think I ran when
the bug hit (I didn't save off the config file :-(  )

But it looks like it did do a mrproper between switching gcc's so I no
longer think that was the issue.

Thanks,

-- Steve


