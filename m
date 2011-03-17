Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab1CQVio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:38:44 -0400
Received: from www.tglx.de ([62.245.132.106]:34471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673Ab1CQVin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:38:43 -0400
Date: Thu, 17 Mar 2011 22:38:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/5] gpio: langwell: Cleanup the interrupt mess
In-Reply-To: <20110317195112.GE12824@angua.secretlab.ca>
Message-ID: <alpine.LFD.2.00.1103172236530.2787@localhost6.localdomain6>
References: <20110317192247.722047296@linutronix.de> <20110317195112.GE12824@angua.secretlab.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Grant Likely wrote:

> On Thu, Mar 17, 2011 at 07:32:43PM -0000, Thomas Gleixner wrote:
> > The langwell interrupt handler is interesting and breaks when an
> > architecture enables GENERIC_HARDIRQS_NO_DEPRECATED.
> > 
> > Also this driver along with the other intel ones should depend on x86.
> > 
> > The series cleans that up. The last patch 5/5 is RFC and needs a
> > close look and testing by folks at Intel.
> 
> Applied first 4, thanks.  Will apply last one when I get acks from the
> Intel folks.

Fair enough.

You should also poke those folks why they did write another driver for
the same gpio IP block. Though I wouldn't be surprised if we have more
than one copy of this in the tree. :(

Thanks,

	tglx
