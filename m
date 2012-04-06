Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab2DFM1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 08:27:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22713 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab2DFM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 08:27:38 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_wMjfnNRlC0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=xIuciQta6A9dcMw8-aMA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 08/15] perf/events: Correct size given to memset
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Arun Sharma <asharma@fb.com>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20120406120021.GF30425@liondog.tnic>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	 <1333666086-6517-9-git-send-email-fweisbec@gmail.com>
	 <20120406112441.GA30425@liondog.tnic> <20120406120021.GF30425@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Apr 2012 08:27:26 -0400
Message-ID: <1333715246.23090.3.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 14:00 +0200, Borislav Petkov wrote:

> > This one is already upstream, you can drop it: 5660ce34241ab
> 
> Uf, nevermind, you're forward-porting those.
> 

Yeah, I worked hard to keep the "author" of the original fixes done in
perf.

-- Steve


