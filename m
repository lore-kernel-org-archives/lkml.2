Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1AOXor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:44:47 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:35063 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1AOXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:44:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gjSQq6k/JClzC2sIHDxuNJjlg1hVlyVj/rhmRFZd7tQg2c5/fAsysGfJ/Tv9n1IE5M
         AG77buYedZgBxJOlgCEPpTw8ZUCWJPyk8KnZkya0h7zk8Zt0lHj3O7CcfRJyDT+YQLFU
         HdWWqVDW6wDxyJyqIlKvl5aE7lR1Z/clvrB4Q=
Date: Sun, 16 Jan 2011 00:44:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 00/28] Removal of trace event semicolons
Message-ID: <20110115234440.GC1768@nowhere>
References: <20110109215927.633266833@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109215927.633266833@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 04:59:27PM -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> I am hereby proposing the removal of trailing semicolons within the trace event
> headers.
> 
> Please refer to "patch 01: TRACE_EVENT: gradual semicolon removal" for
> explanation of this change. This patchset is based on the 2.6.37 kernel.
> 
> Feedback is welcome,
> 
> Thanks,
> 
> Mathieu


So, it seems there is no issue in spreading the whole into
each relevant trees?

The others (core, bkl, lock, sched, etc...) can go through the
tracing tree as often did by the past. Same for some others if
necessary.
