Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1ACP2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:28:54 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56480 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1ACP2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:28:53 -0500
Subject: Re: [PATCH UPDATED] workqueue: relax lockdep annotation on
 flush_work()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110103152017.GV18831@htj.dyndns.org>
References: <20101229125711.GL488@htj.dyndns.org>
	 <1294047091.2016.38.camel@laptop> <20110103141735.GQ18831@htj.dyndns.org>
	 <1294066490.2016.81.camel@laptop> <20110103150052.GU18831@htj.dyndns.org>
	 <1294067685.2016.83.camel@laptop>  <20110103152017.GV18831@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 16:29:05 +0100
Message-ID: <1294068545.2016.85.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 16:20 +0100, Tejun Heo wrote:
> On Mon, Jan 03, 2011 at 04:14:45PM +0100, Peter Zijlstra wrote:
> > > Hmmm?  The code applies the most strict contraints.  If the workqueue
> > > has a rescuer, flushing another work from the workqueue will always
> > > trigger lockdep warning.  The rule is relaxed only for workqueues
> > > which aren't used for memory reclaiming && support parallel execution.
> > 
> > Ah, ok. I read it like: if the current thread is a rescue thread.
> 
> Ah, I see.  Rafael, can you please verify the updated version is okay
> too (it should be but just in case)?  Peter, shall I route this
> through workqueue tree with your ack?

That's fine with me, thanks!
