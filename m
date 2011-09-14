Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab1INP2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:28:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35100 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab1INP16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:27:58 -0400
Subject: Re: [PATCH] sched_rt: Migrate equal priority tasks to available CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Wed, 14 Sep 2011 17:27:49 +0200
In-Reply-To: <1315947117.26295.22.camel@gandalf.stny.rr.com>
References: <1315837684-18733-1-git-send-email-sbohrer@rgmadvisors.com>
	 <1315919147.26295.1.camel@gandalf.stny.rr.com>
	 <20110913162713.GA2362@BohrerMBP.rgmadvisors.com>
	 <20110913200658.GC2362@BohrerMBP.rgmadvisors.com>
	 <1315947117.26295.22.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316014069.5040.23.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 16:51 -0400, Steven Rostedt wrote:
> I ran a version with your patch and I could not trigger the bug. I
> consider this a real regression.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org> 

Thanks Shawn, Steven.

Queued with a CC to stable for 37+.
