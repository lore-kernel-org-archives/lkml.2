Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab2DFATG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:19:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2DFATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:19:04 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_FBgzLvS3gEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=KfXYaXv1OYK0PU0z-kwA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 02/15] tools/events: Add files to create libtraceevent.a
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <4F7E33F6.7050309@gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
	 <1333666086-6517-3-git-send-email-fweisbec@gmail.com>
	 <4F7E33F6.7050309@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Apr 2012 20:18:56 -0400
Message-ID: <1333671536.3764.76.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 18:08 -0600, David Ahern wrote:

> 
> I found that this lib needs to be an .so to work with trace-cmd's plugins.
> 

And not just trace-cmd. I want to get those plugins to also work with
perf. That is, have the kvm plugin (et. al.) make it so that perf does
not need to rely only on the TP_printk() in the format file.

But that said, it is trivial to make this into a .so. Just having a
separate library would be a huge first step.

-- Steve


