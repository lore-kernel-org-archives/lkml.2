Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2EGM51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:57:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11728 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2EGM50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:57:26 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_s2ZMIMYyfwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=HKX9k9qJ-CMDn9P41r8A:9 a=PUjeQqilurYA:10 a=HEdnscJc8mAA:10 a=U62fhAwekXMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336395443.14207.123.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event
 format parsing v3
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Date: Mon, 07 May 2012 08:57:23 -0400
In-Reply-To: <87vck8qtet.fsf@sejong.aot.lge.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
	 <20120507081424.GE16608@gmail.com> <87vck8qtet.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 17:36 +0900, Namhyung Kim wrote:

> I already submitted a patch for it (along with other fixes) to Steven.
> 
>   lkml.indiana.edu/hypermail/linux/kernel/1204.2/03713.html
> 

Thanks for the reminder. I've tested the patches and even added my own
patch on top. But I never pushed it to kernel.org :-p   I think
kernel.org was acting funny that day, so I did other things, and then
forgot that I never did the final step.

Pushed now.

Thanks!

-- Steve


