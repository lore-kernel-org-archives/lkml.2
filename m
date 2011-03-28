Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1C1JxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 05:53:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:53201 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1C1JxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 05:53:07 -0400
Date: Mon, 28 Mar 2011 11:53:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg Ungerer <gerg@snapgear.com>
cc: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: m68knommu: Convert to new irq function names
In-Reply-To: <4D8FD892.3040200@snapgear.com>
Message-ID: <alpine.LFD.2.00.1103281151450.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103251443180.31464@localhost6.localdomain6> <4D8FD892.3040200@snapgear.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Greg Ungerer wrote:

> 
> Hi Thomas,
> 
> On 25/03/11 23:44, Thomas Gleixner wrote:
> > Scripted conversion with coccinelle.
> > 
> > Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> 
> Looks good, and works fine after reworking for the m68k/m68knommu
> merge. Do you want me to carry it for 2.6.40?

That wants to go into .39 so we can get rid of all the compat cruft in
the core code. I really want that to go away, otherwise I play the
same cleanup game over and over.

Thanks,

	tglx
