Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab2BCNu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:50:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2BCNu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:50:58 -0500
Date: Fri, 3 Feb 2012 14:50:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120203135027.GD1531@m.brq.redhat.com>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-3-git-send-email-jolsa@redhat.com>
 <20120130055906.GC22447@somewhere>
 <20120130091832.GA1552@m.brq.redhat.com>
 <1328276560.5882.142.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328276560.5882.142.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 08:42:40AM -0500, Steven Rostedt wrote:
> On Mon, 2012-01-30 at 10:18 +0100, Jiri Olsa wrote:
> 
> > attached new patch :)
> 
> When attaching a new patch, please also include the change log and the
> Signed-off-by. I actually can't take this patch without the SOB.

ok, will do next time

If you want to take 1/7 and 2/7 now I can resend 2/7 right away,
but there's going to be new version for the rest based on Frederic's comments.. 

jirka
