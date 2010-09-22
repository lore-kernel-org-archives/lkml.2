Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0IVSPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0IVSPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:15:51 -0400
Date: Wed, 22 Sep 2010 14:14:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rusty@rustcorp.co.au,
        rostedt@goodmis.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
Message-ID: <20100922181444.GF2816@redhat.com>
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <20100922113114.GA14179@Krystal> <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a8f3ad8416ed61cba1746883da1f839.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 01:56:48PM +0200, Andi Kleen wrote:
> >> +	struct jump_entry *entry;
> >>
> >> +	for (entry = jstart; entry < jstop; entry++)
> >> +		if (entry->code <= (unsigned long)start &&
> >
> > start -> end ?
> 
> I copied this from the original code too. I remember stumbling
> over it too. Yes it was probably wrong in the original too.
> 

No...the original version had it correct, check the archive.

This bug was introduced in your version.

thanks,

-Jason

