Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1KAEot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 00:44:49 -0400
Received: from ozlabs.org ([203.10.76.45]:34065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1KAEos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 00:44:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jason Baron <jbaron@redhat.com>, Nick Bowler <nbowler@elliptictech.com>,
        Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] module: Enable dynamic debugging regardless of taint
In-Reply-To: <1320119973.30281.7.camel@deadeye>
References: <1319773094.6759.32.camel@deadeye> <87obwxq5tz.fsf@rustcorp.com.au> <1320068657.6759.107.camel@deadeye> <87r51svbit.fsf@rustcorp.com.au> <1320119973.30281.7.camel@deadeye>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 01 Nov 2011 15:11:10 +1030
Message-ID: <87lis0v4ih.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Nov 2011 03:59:33 +0000, Ben Hutchings <ben@decadent.org.uk> wrote:
> Dynamic debugging is currently disabled for tainted modules, except
> for TAINT_CRAP.  This prevents use of dynamic debugging for
> out-of-tree modules now that they are also tainted.
> 
> This condition was apparently intended to avoid a crash if a force-
> loaded module has an incompatible definition of dynamic debug
> structures.  However, a administrator that forces us to load a module
> is claiming that it *is* compatible even though it fails our version
> checks.  If they are mistaken, there are any number of ways the module
> could crash the system.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Thanks, applied, unless Mathieu objects...

Cheers,
Rusty.
