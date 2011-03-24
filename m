Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab1CXVtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:49:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:48200 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755846Ab1CXVtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:49:04 -0400
Date: Thu, 24 Mar 2011 22:49:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] gpio: Final genirq cleanups
In-Reply-To: <AANLkTikiPc_EO5xAYR=M7ZdeZMe9mncJPtQeUxtiM5J3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103242248330.31464@localhost6.localdomain6>
References: <20110324212330.292903803@linutronix.de> <AANLkTikiPc_EO5xAYR=M7ZdeZMe9mncJPtQeUxtiM5J3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Grant Likely wrote:

> On Thu, Mar 24, 2011 at 3:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Grant,
> >
> > if possible, please push this lot to Linus for .39. It's cleaning up
> > the missing bits and pieces which are necessary to remove all the
> > compat cruft in the genirq code.
> 
> These look fine.  Since it sounds like you need to base other patches
> on top of these, go ahead and add my Acked-by to all of them and push
> them through your tree.  I don't have any more gpio patches that I'm
> sending to Linus this cycle anyway.

Will do.
 
> g.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks !

       tglx

 
