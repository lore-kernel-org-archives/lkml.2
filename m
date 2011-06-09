Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1FIQ0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:26:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:55575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1FIQ0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:26:07 -0400
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
In-Reply-To: <20110609155134.GA1681@elte.hu>
References: <20110609130647.937204592@chello.nl>
	 <20110609131307.590149293@chello.nl> <20110609133228.GB21100@elte.hu>
	 <1307626856.3941.80.camel@twins> <20110609135542.GD21100@elte.hu>
	 <1307628393.3941.87.camel@twins> <20110609141959.GF21100@elte.hu>
	 <1307629417.3941.89.camel@twins>
	 <BANLkTinbBwH-An0-id6YhCSah_p_bfkVtw@mail.gmail.com>
	 <20110609155134.GA1681@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Jun 2011 18:25:51 +0200
Message-ID: <1307636751.3941.91.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 17:51 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, Jun 9, 2011 at 7:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Subject: printk: Avoid all wakeups from printk
> > > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date: Wed Jun 08 17:29:59 CEST 2011
> > 
> > Looks good to me.  Is it working? You said that some early version 
> > of this caused problems for Ingo?
> 
> Yeah, it locked up during lockup in the middle of a printk and i 
> bisected it back to the third (most dangerous) commit - will retry 
> this version if Peter thinks it's materially different.

Well, please try again, the patch isn't different, but your .config
didn't want to reproduce at all for me, so if you've got a machine that
reliably fails, we can have a poke at it.
