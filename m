Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396Ab2EKPgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:36:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab2EKPgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:36:20 -0400
Message-ID: <1336750573.1017.25.camel@twins>
Subject: Re: Commit cb83b62 fails to boot with a divide by zero error.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Fri, 11 May 2012 17:36:13 +0200
In-Reply-To: <20120511150533.GH3751@sgi.com>
References: <20120511133938.GG3751@sgi.com> <1336746790.1017.17.camel@twins>
	 <20120511150533.GH3751@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 10:05 -0500, Robin Holt wrote:
> On Fri, May 11, 2012 at 04:33:10PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-05-11 at 08:39 -0500, Robin Holt wrote:
> > 
> > > We found that reverting the commit:
> > > cb83b62 (x86/sched/core) sched/numa: Rewrite the CONFIG_NUMA sched domain support
> > > 
> > > also got things working.
> > 
> > there's a particularly stupid bug in that code
> 
> Even with that applied, I still get the divide by zero.

Humm.. what kind of machine is this? And how far along does it get in
booting? ->power isn't supposed to get to 0.
