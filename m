Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab0D3TUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:20:34 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40803 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab0D3Qxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:30 -0400
Date: Thu, 29 Apr 2010 14:57:09 +1000
From: Paul Mackerras <paulus@au1.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: use (C) instead of \251
Message-ID: <20100429045709.GA27842@drongo>
References: <4BD80037.9060704@kernel.org>
 <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 12:41:33AM +0200, Jiri Kosina wrote:

> On Wed, 28 Apr 2010, Tejun Heo wrote:
> 
> > The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
> > causes annoying problems with some editors and tools.  Use (C)
> > instead.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Paul Mackerras <paulus@au1.ibm.com>
> > ---
> > I'm not really sure this would survive transport over mail in
> > appliable form, attaching the patch too just in case.
> 
> It didn't survive :) But it was easy enough to fix by hand. Applied, 
> thanks Tejun.

I tried to reply to this earlier but I think my reply vanished due to
a mail problem.

I don't want "(C)" in there because our lawyers tell me that it is
legally meaningless, but "Copyright" on its own is good enough.
So I would prefer that you either remove the (C) entirely or convert
the copyright symbol to proper UTF-8 (0xc2 0xa9).

Thanks,
Paul.
