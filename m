Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2FWB5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 21:57:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab2FWB5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 21:57:42 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VclqXo_85qrA3VLzZEgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340416659.27036.290.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] perf fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 22 Jun 2012 21:57:39 -0400
In-Reply-To: <4FE51325.8090408@linux.intel.com>
References: <20120622133650.GA24136@gmail.com>
	  <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
	  <20120622183827.GA8014@virgo.local>
	  <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>
	  <20120622190632.GB8014@virgo.local>
	  <1340394896.27036.258.camel@gandalf.stny.rr.com>
	  <86448d73-2e19-416f-8104-ce72aa5d76eb@email.android.com>
	 <1340407123.27036.265.camel@gandalf.stny.rr.com>
	 <4FE51325.8090408@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 17:51 -0700, Arjan van de Ven wrote:

> I would also worry about the compiler being able to inline a function
> containing one of these, but that's a compiler thing, not a CPU type of
> thing.

You missed the beginning of the thread where we talked about the fact
that gcc will not put a mcount (or fentry) in an inlined function, so
that's not a worry.

-- Steve


