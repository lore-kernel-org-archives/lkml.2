Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1K2MWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:22:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1K2MWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:22:11 -0500
Date: Tue, 29 Nov 2011 13:21:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] ftrace, perf: Add FILTER_TRACE_FN event field type
Message-ID: <20111129122154.GF1602@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1322417074-5834-9-git-send-email-jolsa@redhat.com>
 <1322510483.17003.16.camel@frodo>
 <20111129112233.GE1602@m.brq.redhat.com>
 <1322567500.2921.227.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322567500.2921.227.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:51:40PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-29 at 12:22 +0100, Jiri Olsa wrote:
> > On Mon, Nov 28, 2011 at 03:01:23PM -0500, Steven Rostedt wrote:
> > > BTW, Please Cc Peter Zijlstra too, as he maintains perf inside the
> > > kernel.
> > 
> > thanks! ommited by mistake..
> 
> I hope not trimming the email was a mistake too? :-)

Acked-by: Jiri Olsa <jolsa@redhat.com>
