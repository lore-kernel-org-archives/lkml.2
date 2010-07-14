Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0GNCE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:04:56 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:39584 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GNCEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:04:55 -0400
Date: Tue, 13 Jul 2010 21:01:19 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Heinz Diehl <htd@fancy-poultry.org>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <20100713135650.GA6444@fancy-poultry.org>
Message-ID: <alpine.DEB.2.00.1007132055470.14067@router.home>
References: <20100709190706.938177313@quilx.com> <20100710195621.GA13720@fancy-poultry.org> <alpine.DEB.2.00.1007121010420.14328@router.home> <20100712163900.GA8513@fancy-poultry.org> <alpine.DEB.2.00.1007121156160.18621@router.home>
 <20100713135650.GA6444@fancy-poultry.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1007132055472.14067@router.home>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Heinz Diehl wrote:

> On 13.07.2010, Christoph Lameter wrote:
>
> > Can you get us the config file. What is the value of
> > PERCPU_DYMAMIC_EARLY_SIZE?
>
> My .config file is attached. I don't know how to find out what value
> PERCPU_DYNAMIC_EARLY_SIZE is actually on, how could I do that? There's
> no such thing in my .config.

I dont see anything in there at first glance that would cause slub to
increase its percpu usage. This is straight upstream?

Try to just comment out the BUILD_BUG_ON. I had it misfire before and
fixed the formulae to no longer give false positives. Maybe that is
another case. Tejun wanted that but never was able to give me an exact
formular to check for.

At the Ottawa Linux Symposium right now so responses may be delayed.
Hotels Internet connection keeps getting clogged for some reason.


