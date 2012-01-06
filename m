Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2AFIxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:53:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab2AFIxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:53:06 -0500
Date: Fri, 6 Jan 2012 09:51:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120106085104.GE14188@elte.hu>
References: <20120102134856.GA32673@elte.hu>
 <1325635373.12696.4.camel@gandalf.stny.rr.com>
 <1325635922.12696.8.camel@gandalf.stny.rr.com>
 <1325653301.12696.20.camel@gandalf.stny.rr.com>
 <20120104141107.GA24770@elte.hu>
 <1325696759.12696.24.camel@gandalf.stny.rr.com>
 <20120105091916.GA22598@elte.hu>
 <1325764011.12696.38.camel@gandalf.stny.rr.com>
 <1325765791.12696.41.camel@gandalf.stny.rr.com>
 <1325825918.12696.64.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325825918.12696.64.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Not sure what else to do. Have you been able to trigger these 
> bugs without my patches? All the bugs I've been hitting after 
> merging my patches, I've been able to hit with tip/master as 
> well.

No, as i described to you the tree(s) without your patches all 
did 50+ series of bootups.

Thanks,

	Ingo
