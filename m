Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab1HRUGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:06:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53175 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1HRUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:06:32 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=_E3Q4npPQ1wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uOokNiSl2Gp-GhqbTokA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on
 ftrace nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
In-Reply-To: <4E4BB041.1050004@hitachi.com>
References: <20110810162222.017387055@goodmis.org>
	 <4E43209D.7090104@hitachi.com>
	 <1313022842.18583.282.camel@gandalf.stny.rr.com>
	 <4E43769C.9000901@hitachi.com>
	 <1313067691.18583.290.camel@gandalf.stny.rr.com>
	 <4E44967C.1090101@hitachi.com>
	 <1313154537.18583.319.camel@gandalf.stny.rr.com>
	 <4E464D6C.9020807@hitachi.com>
	 <1313290684.18583.362.camel@gandalf.stny.rr.com>
	 <4E47A33E.5020202@hitachi.com>
	 <1313413562.15704.5.camel@gandalf.stny.rr.com>
	 <4E4BB041.1050004@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 16:06:28 -0400
Message-ID: <1313697988.15704.77.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 21:12 +0900, Masami Hiramatsu wrote:

> I see. OK, I'm now looking forward to your work ;)

Hi Masami,

BTW, do you have any test suits that I could use to test the changes I
make. Something that I may be able to catch regressions with?

Thanks!

-- Steve


