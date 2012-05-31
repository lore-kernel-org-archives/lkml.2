Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab2EaRoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:44:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:38218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2EaRoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:44:54 -0400
Message-ID: <1338486283.28384.95.camel@twins>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 19:44:43 +0200
In-Reply-To: <1338486029.28384.93.camel@twins>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 19:40 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-31 at 10:08 -0400, Steven Rostedt wrote:
> > > Also, why does this stuff live in ftrace? I always thought you were
> > > going to replace text_poke() so everybody that uses cross-modifying code
> > > could profit?
> > 
> > I discussed this with Masami at Collaboration Summit. The two are
> > similar but also very different. But we want to start merging the two
> > together where it makes sense. 
> 
> Argh,. I so disagree. You're doing it backwards.
> 
> First you merge whatever is there, regardless of who came first.

The thing is, that's useful even if the new stuff never works. Having
two code-bases doing cross-modifying code in different ways just doesn't
sound right. That stuff is tricky enough as it is.


