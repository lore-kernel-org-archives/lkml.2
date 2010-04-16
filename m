Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0DPQA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 12:00:56 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:41627 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0DPQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 12:00:54 -0400
Date: Fri, 16 Apr 2010 11:00:29 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: useless node/has_cpu sysfs attribute
In-Reply-To: <20100416072652.GA4489@alberich.amd.com>
Message-ID: <alpine.DEB.2.00.1004161058020.7710@router.home>
References: <20100415061200.GC21517@alberich.amd.com> <alpine.DEB.2.00.1004151917420.17800@router.home> <20100416072652.GA4489@alberich.amd.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010, Andreas Herrmann wrote:

> Why don't we try to call node_clear_state(node, N_CPU)
> anywhere? (Maybe there is such a call and I missed it.)

There is none since it would require a scan of all processors to see if a
certain node is still used. Seems that this was not implemented.

> Do we want to list each node with this attribute that has a CPU
> regardless whether the CPU is actually offline or online?

Nope.

> That is the reason why I wanted to know who is relying on this
> attribute and what are the use cases of it.

Obviously not many right now since the breakage went unnoticed. There is
certainly going to be more usage with the high end processors requiring
NUMA. Would be glad if you could clear up the situation, fix breakage and
implement missing functionality.

