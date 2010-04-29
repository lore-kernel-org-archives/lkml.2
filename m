Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0D3RSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:18:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933035Ab0D3RSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:18:10 -0400
Date: Thu, 29 Apr 2010 14:15:09 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       vgoyal@redhat.com
Subject: Re: [PATCH 00/11] jump label v7
Message-ID: <20100429181508.GE3960@redhat.com>
References: <cover.1271427118.git.jbaron@redhat.com> <20100422.161700.191166551.davem@davemloft.net> <20100427.175858.134109609.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427.175858.134109609.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 05:58:58PM -0700, David Miller wrote:
> > 
> >> David, I re-worked the sparc64 to match the updated interfaces. The
> >> code should hopefully compile now, although I did not test the sparc
> >> bits.
> > 
> > Thanks for working on this Jason.  I'll take a close look at this
> > some time today.
> 
> The kernel stops compiling after the second patch because
> kernel/jump_label.c is compiled unconditionally, and this generates an
> attempt to include asm/alternatives.h which is an x86-only phenomenon.
> 

sorry. jump_label.c no longer requires asm/alternatives.h. It should
have been removed in this patch series.

> Do you have access to a cross-compile environment or at least some
> non-x86 system you can test build on before submitting these patch
> sets?
> 

I'll make sure to test the next iteration on non-x86, with at least
dummy funtions.

thanks,

-Jason

