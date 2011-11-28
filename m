Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1K1UKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:10:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:60067 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1K1UKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:10:17 -0500
Message-ID: <1322511002.2921.171.camel@twins>
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:10:02 +0100
In-Reply-To: <1322510931.2921.170.camel@twins>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
	 <1322510318.17003.14.camel@frodo> <1322510931.2921.170.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 21:08 +0100, Peter Zijlstra wrote:
> > Is it really an issue that we shouldn't call the full blown register
> > instead? I'm not really understanding why this is a problem. Note, one
> > of the improvements to ftrace in the near future is to enable ftrace
> > without stop_machine. 
> 
> Yeah, but still not something you want to do during context switches,
> right? 

Also, that's x86, there's still archs that need stop_machine(), right?
