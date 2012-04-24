Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2DXAlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:41:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21158 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2DXAlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:41:39 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=02riegOredAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=a3uHjiXsAAAA:8 a=zbgYz0kmtc3a9ZeXGMIA:9 a=PUjeQqilurYA:10 a=p3BLKSnE_igA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335228097.28106.127.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/7] parse-events: Handle strdup failure cases
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 20:41:37 -0400
In-Reply-To: <87ehrermop.fsf@sejong.aot.lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
	 <1333940074-19052-5-git-send-email-namhyung.kim@lge.com>
	 <1335196274.28106.101.camel@gandalf.stny.rr.com>
	 <87ehrermop.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 09:35 +0900, Namhyung Kim wrote:

> > I just added this patch, but we need to get rid of all the "die"
> > functions and do proper freeing and error notifications to make this a
> > real library.
> >
> 
> Agreed. I'm planning to dive into it soonish..

Great! One more thing for me to take of my TODO list :-)

-- Steve


