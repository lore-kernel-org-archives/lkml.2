Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2BCOIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:08:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab2BCOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:08:50 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=ravTz9YwjkQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=szJe_jwy7Pm65yGNK44A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328278128.5882.145.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 03 Feb 2012 09:08:48 -0500
In-Reply-To: <20120203135027.GD1531@m.brq.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1327776209-4883-3-git-send-email-jolsa@redhat.com>
	 <20120130055906.GC22447@somewhere> <20120130091832.GA1552@m.brq.redhat.com>
	 <1328276560.5882.142.camel@gandalf.stny.rr.com>
	 <20120203135027.GD1531@m.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 14:50 +0100, Jiri Olsa wrote:

> If you want to take 1/7 and 2/7 now I can resend 2/7 right away,
> but there's going to be new version for the rest based on Frederic's comments.. 

Yeah, you can send the 2 patches as a separate series, and I'll start
running them through my tests.

Thanks,

-- Steve


