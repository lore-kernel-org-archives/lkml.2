Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2HXHht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:37:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39801 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2HXHhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:37:47 -0400
Date: Fri, 24 Aug 2012 13:07:38 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, peterz@infradead.org,
        oleg@redhat.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120824073738.GD32031@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120822082205.GA29216@in.ibm.com> <20120822082708.GB29216@in.ibm.com> <1345696100.3338.21.camel@concordia> <20120823055820.GA14603@in.ibm.com> <1345770803.13865.10.camel@concordia> <1345792051.29170.25.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345792051.29170.25.camel@pasglop>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082407-2356-0000-0000-0000018C758E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 05:07:31PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2012-08-24 at 11:13 +1000, Michael Ellerman wrote:
> > 
> > Yeah. A NULL regs here is a kernel bug, so I think it's actually
> > preferable to crash than silently return. 
> 
> Or best, if you think there's a remote chance that the bug might hit:
> 
> 	if (WARN(!regs))
> 		return

Incorporated this and other suggestions from Michael in v5 I just
posted.

Ananth

