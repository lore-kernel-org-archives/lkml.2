Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0EESQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:16:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:32842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0EESQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:16:51 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1273083173.1642.250.camel@laptop>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272994165.1642.203.camel@laptop> <4BE0FB68.7080403@kernel.org>
	 <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org>
	 <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org>
	 <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org>
	 <20100505165532.GC14323@elte.hu>  <1273083173.1642.250.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 20:16:36 +0200
Message-ID: <1273083396.1642.251.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 20:15 +0200, Peter Zijlstra wrote:
> 
> Well, I'd much rather just see a direct call in the code than having to
> reverse engineer wth hangs onto that _EVENT() junk.

And again, I oppose mandating CONFIG_TRACEEVENT.

