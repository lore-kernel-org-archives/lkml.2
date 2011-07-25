Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1GYSUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:20:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1GYSUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:20:41 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=yFouZXgJKjEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0azM3ZO7AAAA:8 a=iYi5UPBRHxpa-eNom4QA:9 a=PUjeQqilurYA:10 a=BGWj8ct6lkoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][Trivial] Update version number reference to new 3.x
 scheme for EVENT_POWER_TRACING_DEPRECATED
From: Steven Rostedt <rostedt@goodmis.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107242313550.7103@swampdragon.chaosbits.net>
	 <20110725062743.GB694@elte.hu>
	 <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 14:20:38 -0400
Message-ID: <1311618038.3526.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 09:30 +0200, Jesper Juhl wrote:
> On Mon, 25 Jul 2011, Ingo Molnar wrote:
> 
> > 
> > * Jesper Juhl <jj@chaosbits.net> wrote:
> > 
> > > What was scheduled to be 2.6.41 is now going to be 3.1 .
> > > 
> > > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > 
> > SOB missing.
> > 
> 
> Whoops.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 

Ingo, I'm back from vacation. Want me to pull this in. I'll probably
make a list of things to pull in for 3.1 and some things for 3.2.

-- Steve


