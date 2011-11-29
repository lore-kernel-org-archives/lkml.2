Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1K2LwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:52:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:41546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1K2LwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:52:05 -0500
Message-ID: <1322567500.2921.227.camel@twins>
Subject: Re: [PATCH 8/9] ftrace, perf: Add FILTER_TRACE_FN event field type
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Nov 2011 12:51:40 +0100
In-Reply-To: <20111129112233.GE1602@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-9-git-send-email-jolsa@redhat.com>
	 <1322510483.17003.16.camel@frodo> <20111129112233.GE1602@m.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:22 +0100, Jiri Olsa wrote:
> On Mon, Nov 28, 2011 at 03:01:23PM -0500, Steven Rostedt wrote:
> > BTW, Please Cc Peter Zijlstra too, as he maintains perf inside the
> > kernel.
> 
> thanks! ommited by mistake..

I hope not trimming the email was a mistake too? :-)
