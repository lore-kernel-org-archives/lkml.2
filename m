Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1JYPjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:39:14 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:55942 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1JYPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:39:13 -0400
Date: Tue, 25 Oct 2011 11:38:55 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111025153855.GA24779@elliptictech.com>
References: <1319461948.31243.31.camel@deadeye>
 <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k47tpvvm.fsf@rustcorp.com.au>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-25 14:26 +1030, Rusty Russell wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
> Subject: module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree
> Date: Mon, 24 Oct 2011 15:12:28 +0200
> 
> Use of the GPL or a compatible licence doesn't necessarily make the code
> any good.  We already consider staging modules to be suspect, and this
> should also be true for out-of-tree modules which may receive very
> little review.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Reviewed-by: Dave Jones <davej@redhat.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (patched oops-tracing.txt)
> ---
>  Documentation/oops-tracing.txt |    2 ++
>  include/linux/kernel.h         |    1 +
>  kernel/module.c                |    5 +++++
>  kernel/panic.c                 |    2 ++
>  scripts/mod/modpost.c          |    7 +++++++
>  5 files changed, 17 insertions(+)

This patch prevents the use of lockdep for debugging out of tree
modules, which is rather mean.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
