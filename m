Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab2CWMpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab2CWMpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:45:40 -0400
Date: Fri, 23 Mar 2012 13:45:26 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86: io_apic: Move and reenable irq only when
 CONFIG_GENERIC_PENDING_IRQ=y
Message-ID: <20120323124525.GB21907@dhcp-26-207.brq.redhat.com>
References: <20120320141935.GA24806@dhcp-26-207.brq.redhat.com>
 <20120323123503.GH13920@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323123503.GH13920@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:35:03PM +0100, Ingo Molnar wrote:
> 
> * Alexander Gordeev <agordeev@redhat.com> wrote:
> 
> > When CONFIG_GENERIC_PENDING_IRQ=n irq move and reenable code 
> > is never get executed, nor do_unmask_irq variable updates its 
> > init value. Move the code under CONFIG_GENERIC_PENDING_IRQ 
> > macro.
> 
> It's not clear from the changelog what it does though, and the
> #ifdefs are quite a mess. Does the patch fix some real bug? Or 
> does it remove dead code from certain .config variations?

It just removes a dead code. Can reword if it worth it.

> Thanks,
> 
> 	Ingo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
