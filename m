Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0EUKTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:19:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0EUKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CCIPGzaFiIZohiSJ0c1f+toWGBYMbpCQL+GiU95jCgxX0fQ88DrGst6nfhSB1EuicK
         Wuf3SOAF3tbjt/r2KsJgXlOZoN2651/+gic5Rkc8nx3BZP/mH6+/S1GR/kpzIr/nB8o6
         6SX2NFKAgSm/50MHZNyjNPetGtDV5Gk1vl2sE=
Date: Fri, 21 May 2010 12:19:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
	track events
Message-ID: <20100521101917.GD30108@nowhere>
References: <20100521090201.326791353@chello.nl> <20100521090710.473188012@chello.nl> <20100521094014.GA30108@nowhere> <1274436125.1674.1690.camel@laptop> <20100521101347.GC30108@nowhere> <1274436943.1674.1693.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274436943.1674.1693.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 12:15:43PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-05-21 at 12:13 +0200, Frederic Weisbecker wrote:
> > > What exactly is the puzzlement about?
> 
> > The fact we use the hlist API not for hlist purpose but for a list.
> 
> I might miss the confusion, but hlist _are_ lists. Its just that their
> structure is slightly different that the regular struct list_head stuff.
> 


It's just that people might except this is used for a hlist purpose.

But nevermind, that's just a small issue.

