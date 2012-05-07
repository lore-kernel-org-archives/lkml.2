Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2EGNBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:01:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15642 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2EGNBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:01:37 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_s2ZMIMYyfwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=D7wu3iO68CKWo3LFmncA:9 a=p6BcPCEM-pko-u6xm9MA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336395695.14207.125.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/15] tools: Unify perf and trace-cmd trace event
 format parsing v3
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Julia Lawall <julia@diku.dk>, Tom Zanussi <tzanussi@gmail.com>,
        David Ahern <dsahern@gmail.com>
Date: Mon, 07 May 2012 09:01:35 -0400
In-Reply-To: <20120507081424.GE16608@gmail.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
	 <20120507081424.GE16608@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 10:14 +0200, Ingo Molnar wrote:

> It gives me:
> 
> /home/mingo/tip/tools/lib/traceevent/parse-filter.c: In function ‘create_arg_item’:
> /home/mingo/tip/tools/lib/traceevent/parse-filter.c:343:9: warning: comparison between ‘enum filter_arg_type’ and ‘enum event_type’ [-Wenum-compare]
> /home/mingo/tip/tools/lib/traceevent/parse-filter.c:339:2: warning: case value ‘8’ not in enumerated type ‘enum filter_arg_type’ [-Wswitch]

Note, older gcc did not error with these (as I'm still on F13 I have an
older gcc). Otherwise I would have fixed them a long time ago. And
-Werror would have not helped.


-- Steve


