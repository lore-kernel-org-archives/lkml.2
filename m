Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0FQIgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:36:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:44704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab0FQIgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:36:04 -0400
Subject: Re: [PATCH 2/6: v4] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       ghaskins@novell.com
In-Reply-To: <1276723773.3556.65.camel@gandalf.stny.rr.com>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
	 <1276554087-3632-3-git-send-email-jkacur@redhat.com>
	 <1276714154.1745.623.camel@laptop>
	 <alpine.LFD.2.00.1006162213220.28756@localhost.localdomain>
	 <1276723008.2077.9574.camel@twins>
	 <1276723773.3556.65.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Jun 2010 10:35:19 +0200
Message-ID: <1276763719.27822.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 17:29 -0400, Steven Rostedt wrote:
> On Wed, 2010-06-16 at 23:16 +0200, Peter Zijlstra wrote:
> 
> > Also, google doesn't seem to index msg-ids, so I've no idea what you're
> > referring to.
> 
> But marc.info does:
> 
> http://marc.info/?i=4BCEAD7B0200005A0006513E@soto.provo.novell.com

Right, so that was before Yong Zhang's patch, if it still happens we
need to again look at what is causing this. Again, blindly increasing
the limit is not a good option.
