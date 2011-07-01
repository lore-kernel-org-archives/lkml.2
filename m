Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1GAXLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:11:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:39031 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801Ab1GAXLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:11:33 -0400
Subject: Re: [PATCH 1/2] mm: Move definition of MIN_MEMORY_BLOCK_SIZE to a
 header
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20110701121408.GC28008@elte.hu>
References: <1308013070.2874.784.camel@pasglop>
	 <20110701121408.GC28008@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jul 2011 09:11:06 +1000
Message-ID: <1309561866.14501.254.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 14:14 +0200, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > The macro MIN_MEMORY_BLOCK_SIZE is currently defined twice in two .c
> > files, and I need it in a third one to fix a powerpc bug, so let's
> > first move it into a header
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> > Ingo, Thomas: Who needs to ack the x86 bit ? I'd like to send that
> > to Linus asap with the powerpc fix.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> (btw., you can consider obvious cleanups as being implicitly acked by 
> me and don't need to block fixes on me.)

Ok thanks !

Cheers,
Ben.


