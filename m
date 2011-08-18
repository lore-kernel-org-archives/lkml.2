Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1HRPQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:16:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47311 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab1HRPQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:16:02 -0400
Date: Thu, 18 Aug 2011 17:15:57 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, stable@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding logical
 APIC ID mismatches
Message-ID: <20110818151557.GE20085@htj.dyndns.org>
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
 <20110818130424.GC20085@htj.dyndns.org>
 <4E4D36980200007800051D6E@nat28.tlf.novell.com>
 <20110818140216.GD20085@htj.dyndns.org>
 <4E4D47A30200007800051DAC@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4D47A30200007800051DAC@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 04:10:59PM +0100, Jan Beulich wrote:
> > Hmmm... the only thing it can break is numa affinity of static percpu
> > areas (it doesn't even affect that anymore), which didn't work at all
> > on i386 before and keeps to not working for those exotic apic machines
> > anyway.  Silencing the warnings wouldn't hurt anything at all.  If
> > you're still concerned that something legitimate might trigger it,
> > wouldn't converting WARN_ON() there to printk_once() be enough?  That
> > doesn't change the behavior at all sans lesser noise.
> 
> That might be reasonable to do, yet I still think that changing what got
> produced with by the older APIC driver to what the new one would have
> produced when the driver gets changed is more consistent than just
> printing something, until the method in question is gone altogether.

Sure, either seems fine to me.  Please feel free to add my acked-by.
Thanks.

-- 
tejun
