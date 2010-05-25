Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab0EYURr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:17:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51931 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0EYURq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ipuctdg/Rvu+KDrVUgz4bEneje7s6jPqgt6LS5AMq6+6c6PTBvZ5XlG6kYfOaEvAbr
         L/uSyImphWgRnzftiUo0NT2001BeSYAfztTshZ85dHeilr0oMd5Uen9h+vcioBHcWqrg
         xxrNHS4t+X0VKySnWzteOlvFYb3mDR3M3R4eo=
Date: Tue, 25 May 2010 22:17:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Tracing configuration review
Message-ID: <20100525201736.GB5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu> <1274816768.22648.220.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274816768.22648.220.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 03:46:08PM -0400, Steven Rostedt wrote:
> On Tue, 2010-05-25 at 15:31 -0400, Chase Douglas wrote:
> > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> 
> Although it is headed for deprecation, I think it still gets set by
> other tracers, since it has the code to initiate the comm reader.



Doesn't actually CONTEXT_SWITCH_TRACER has the code for the
comm things?


> > CONFIG_BOOT_TRACER=y (no performance impact by default)
> 
> But this tracer is pretty useless. It gives no more information than
> debug_initcalls.



Yeah it's pretty useless. And these informations can also be displayed
through printk on boot so...

