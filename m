Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2BCNmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:42:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39868 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab2BCNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:42:41 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ravTz9YwjkQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FI9SWDrMZs8yI32vDKIA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328276560.5882.142.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 03 Feb 2012 08:42:40 -0500
In-Reply-To: <20120130091832.GA1552@m.brq.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-3-git-send-email-jolsa@redhat.com>
	 <20120130055906.GC22447@somewhere> <20120130091832.GA1552@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 10:18 +0100, Jiri Olsa wrote:

> attached new patch :)

When attaching a new patch, please also include the change log and the
Signed-off-by. I actually can't take this patch without the SOB.

Thanks,

-- Steve


