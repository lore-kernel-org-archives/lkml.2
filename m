Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2JSUyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 16:54:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45722 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2JSUyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 16:54:12 -0400
Date: Fri, 19 Oct 2012 22:54:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/2] rename NUMA fault handling functions
Message-ID: <20121019205407.GA9132@gmail.com>
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>
 <20121018172021.0b1f6e3d@cuia.bos.redhat.com>
 <1350646863.30157.13.camel@twins>
 <50815EA5.5080502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50815EA5.5080502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 10/19/2012 07:41 AM, Peter Zijlstra wrote:
> >On Thu, 2012-10-18 at 17:20 -0400, Rik van Riel wrote:
> >>Having the function name indicate what the function is used
> >>for makes the code a little easier to read.  Furthermore,
> >>the fault handling code largely consists of do_...._page
> >>functions.
> >
> > I don't much care either way, but I was thinking walken 
> > might want to use something similar to do WSS estimation, in 
> > which case the NUMA name is just as wrong.
> 
> That's a good point. I had not considered other uses of the 
> same code.

Renaming the functions for more clarity still makes sense IMO: 
we could give it a _wss or _working_set prefix/postfix?

Thanks,

	Ingo
