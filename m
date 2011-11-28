Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1K1UEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:04:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1K1UEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:04:13 -0500
Message-ID: <1322510636.2921.168.camel@twins>
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 21:03:56 +0100
In-Reply-To: <1322510318.17003.14.camel@frodo>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
	 <1322510318.17003.14.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 14:58 -0500, Steven Rostedt wrote:
> >   perf stat -e ftrace:function ls
> 
> Question. This is a root only command, correct? Otherwise, we are
> allowing any user to create a large performance impact to the system. 

Typically not, although I haven't looked at Jiri's implementation of the
function tracepoint.


