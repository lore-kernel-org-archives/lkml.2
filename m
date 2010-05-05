Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab0EEJvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:51:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:48262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934157Ab0EEJvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:51:21 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <4BE13B33.3030709@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>
	 <1273050400.1642.229.camel@laptop>  <4BE13B33.3030709@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 11:51:13 +0200
Message-ID: <1273053073.1642.235.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 11:32 +0200, Tejun Heo wrote:
> 
> > Well, I already utterly hate that x86 can't build with !
> > CONFIG_PERF_EVENTS, also requiring CONFIG_TRACEPOINTS is going the wrong
> > way.
> > 
> > I've always explicitly avoided depending on tracepoints, and I'd very
> > much like to keep it that way.
> 
> I was wondering the other way around - ie. the possibility to make
> perf optional and maybe even as a module which depends on TPs, which
> would be nicer than the current situation and make the code less
> cluttered too. 

I really really hate making perf rely on tracepoints.

