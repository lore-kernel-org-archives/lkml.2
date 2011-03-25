Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1CYLyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:54:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:40277 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750959Ab1CYLyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:54:19 -0400
Date: Fri, 25 Mar 2011 12:54:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen: Use new irq_move functions
In-Reply-To: <1301047442.11560.194.camel@cthulhu.hellion.org.uk>
Message-ID: <alpine.LFD.2.00.1103251253290.31464@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103242135380.31464@localhost6.localdomain6> <1301047442.11560.194.camel@cthulhu.hellion.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Ian Campbell wrote:

> On Thu, 2011-03-24 at 20:37 +0000, Thomas Gleixner wrote:
> > These functions take irq_data as an argument and avoid a redundant
> > lookup in the sparse irq case.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Looks good to me.
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Do you want to carry this in your tree or shall we pick it up? (not sure
> if this is part of a wider treewide series or not)

Works either way as long as we get it into .39 so we can cleanup the
old stuff. Ditto for the namespace.

Thanks,

	tglx
