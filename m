Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1FOP0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:26:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:49657 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab1FOP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:26:04 -0400
Date: Wed, 15 Jun 2011 17:25:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Ben Hutchings <bhutchings@solarflare.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: don't use flush_scheduled_work() in IRQ affinity
 notifiers
In-Reply-To: <20110615143029.GZ8141@htj.dyndns.org>
Message-ID: <alpine.LFD.2.02.1106151725460.11814@ionos>
References: <20110615142917.GY8141@htj.dyndns.org> <20110615143029.GZ8141@htj.dyndns.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Tejun Heo wrote:

> On Wed, Jun 15, 2011 at 04:29:17PM +0200, Tejun Heo wrote:
> > cd7eab44e9 (genirq: Add IRQ affinity notifiers) added use of
> > flush_scheduled_work() which is being deprecated.  Add a dedicated
> > workqueue and flush it instead of flushing system-wide workqueue.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ben Hutchings <bhutchings@solarflare.com>
> > ---
> > I'm planning on marking flush_scheduled_work() deprecated in
> > linux-next soonish.  It would be great if this patch (or something
> > else which removes flush_scheduled_work() call somehow) can be
> > included in linux-next.
> 
> Ooh, right, only compile & boot tested.  Don't have anything which
> makes use of affinity notifier.

Ben?
